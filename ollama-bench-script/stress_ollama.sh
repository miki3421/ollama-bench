#!/usr/bin/env bash
set -euo pipefail

# Runs a Vegeta stress test against a locally-running Ollama container and
# asks Ollama to comment on the resulting report.

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$here"

DOCKER_NET="${DOCKER_NET:-nuvolaris-ollama}"
OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://ollama:11434}"
uid_gid="$(id -u):$(id -g)"

# Model used for the benchmarked endpoint (keep it small for repeatability).
BENCH_MODEL="${BENCH_MODEL:-bestia/tiny:1b}"

# Model used to comment on the report (can be larger).
ANALYSIS_MODEL="${ANALYSIS_MODEL:-bestia/small:3b}"

reports_dir="$here/reports"
mkdir -p "$reports_dir"

# Clean up leftover temp files from previous runs (keep reports).
rm -f "$reports_dir"/*.tmp "$reports_dir"/*.dedup 2>/dev/null || true

models_json="$(docker run --rm --network "$DOCKER_NET" curlimages/curl:8.5.0 -sS "${OLLAMA_BASE_URL}/api/tags" || true)"
if [[ -n "$models_json" ]] && echo "$models_json" | jq -e '.models and (.models | length) > 0' >/dev/null 2>&1; then
  mapfile -t models < <(echo "$models_json" | jq -r '.models[].name' | awk 'NF' )

  echo "Available models on Ollama:"
  printf '%s\n' "${models[@]}" | nl -w2 -s') '

  read -rp "Select benchmark model (number or name, Enter=default ${BENCH_MODEL}): " model_choice
  if [[ -z "${model_choice}" ]]; then
    : # keep default
  elif [[ "${model_choice}" =~ ^[0-9]+$ ]]; then
    idx=$(( model_choice - 1 ))
    if (( idx < 0 || idx >= ${#models[@]} )); then
      echo "Error: invalid selection (1-${#models[@]})." >&2
      exit 2
    fi
    BENCH_MODEL="${models[$idx]}"
  else
    if printf '%s\n' "${models[@]}" | rg -Fxq -- "${model_choice}"; then
      BENCH_MODEL="${model_choice}"
    else
      echo "Error: model '${model_choice}' not found in the list." >&2
      exit 2
    fi
  fi
else
  echo "Note: unable to read model list from ${OLLAMA_BASE_URL}/api/tags. Using BENCH_MODEL=${BENCH_MODEL}." >&2
fi

read -rp "Stress level (1-10): " level
if [[ ! "$level" =~ ^([1-9]|10)$ ]]; then
  echo "Error: enter a number from 1 to 10." >&2
  exit 2
fi

# Simple scaling rule: keep it predictable and not too destructive by default.
rate="$(( level * 2 ))/s"
duration="$(( 5 + level ))s"
timeout="180s"

ts="$(date +%Y%m%d_%H%M%S)"

run_dir="$reports_dir/$ts"
mkdir -p "$run_dir"

targets="$run_dir/targets.txt"
body="$run_dir/body.json"
meta="$run_dir/meta.json"
results="$run_dir/vegeta.gob"
report_txt="$run_dir/vegeta.report.txt"
report_json="$run_dir/vegeta.report.json"
analysis_md="$run_dir/vegeta.analysis.md"

cat >"$targets" <<EOF
POST ${OLLAMA_BASE_URL}/api/chat
EOF

cat >"$body" <<EOF
{
  "model": "${BENCH_MODEL}",
  "messages": [
    { "role": "user", "content": "ping" }
  ],
  "stream": false,
  "options": {
    "temperature": 0,
    "num_predict": 32
  }
}
EOF

jq -n \
  --arg ts "$ts" \
  --arg endpoint "${OLLAMA_BASE_URL}/api/chat" \
  --arg docker_network "$DOCKER_NET" \
  --arg bench_model "$BENCH_MODEL" \
  --arg analysis_model "$ANALYSIS_MODEL" \
  --arg rate "$rate" \
  --arg duration "$duration" \
  --arg timeout "$timeout" \
  '{
    ts: $ts,
    endpoint: $endpoint,
    docker_network: $docker_network,
    bench_model: $bench_model,
    analysis_model: $analysis_model,
    vegeta: {rate: $rate, duration: $duration, timeout: $timeout}
  }' >"$meta"

echo "Running vegeta: rate=${rate} duration=${duration} timeout=${timeout}"

docker run --rm \
  -u "$uid_gid" \
  --network "$DOCKER_NET" \
  -v "$targets:/in/targets.txt:ro" \
  -v "$body:/in/body.json:ro" \
  -v "$run_dir:/out" \
  peterevans/vegeta sh -lc \
  "vegeta attack \
     -targets=/in/targets.txt \
     -rate='${rate}' \
     -duration='${duration}' \
     -timeout='${timeout}' \
     -header='Content-Type: application/json' \
     -header='Accept: application/json' \
     -body=/in/body.json \
     -output=/out/vegeta.gob && \
   vegeta report /out/vegeta.gob > /out/vegeta.report.txt && \
   vegeta report --type=json /out/vegeta.gob > /out/vegeta.report.json"

echo "Report written to: $report_txt"

report_text="$(cat "$report_txt")"
report_json_text="$(cat "$report_json")"

# Pre-compute metrics (avoid LLM hallucinating numbers).
metrics_json="$(
  jq -c '{
    requests,
    rate,
    throughput,
    success,
    status_codes,
    errors_count: (.errors | length),
    lat_ms: {
      min: (.latencies.min / 1e6),
      mean: (.latencies.mean / 1e6),
      p50: (.latencies["50th"] / 1e6),
      p90: (.latencies["90th"] / 1e6),
      p95: (.latencies["95th"] / 1e6),
      p99: (.latencies["99th"] / 1e6),
      max: (.latencies.max / 1e6)
    },
    bytes_in_total: .bytes_in.total,
    bytes_in_mean: .bytes_in.mean,
    bytes_out_total: .bytes_out.total,
    bytes_out_mean: .bytes_out.mean,
    duration_s: (.duration / 1e9),
    wait_s: (.wait / 1e9)
  }' "$report_json"
)"

# Always include metadata header (models + run parameters) in the analysis file.
analysis_header="$(
  cat <<EOF
# Ollama Stress Test Analysis (Vegeta)

- Timestamp: ${ts}
- Endpoint: ${OLLAMA_BASE_URL}/api/chat
- Docker network: ${DOCKER_NET}
- Benchmark model: ${BENCH_MODEL}
- Analysis model: ${ANALYSIS_MODEL}
- Vegeta rate: ${rate}
- Vegeta duration: ${duration}
- Timeout: ${timeout}

EOF
)"

prompt="$(
  cat <<EOF
You are an SRE/Performance Engineer. Comment on this Vegeta stress test against Ollama.
Constraints: do not make up numbers. If a value isn't present in the report, write "not determinable from the report".
Use only the numbers in "Metrics (JSON)" (do not recompute from other strings).
At the end, include a "Final comment" section with 1-3 sentences.

Context:
- Endpoint: ${OLLAMA_BASE_URL}/api/chat
- Docker network: ${DOCKER_NET}
- Model: ${BENCH_MODEL}
- Vegeta rate: ${rate}
- Vegeta duration: ${duration}
- Timeout: ${timeout}

Report (text):
${report_text}

Report (JSON):
${report_json_text}

Metrics (JSON):
${metrics_json}

Required output (in English):
- Section "Key metrics": exactly 5 bullets.
- Section "Bottlenecks": exactly 3 bullets.
- Section "Next experiments": exactly 5 bullets.
- Section "Final comment": 1-3 sentences, must explicitly mention the model (${BENCH_MODEL}).
EOF
)"

payload="$(jq -n \
  --arg model "$ANALYSIS_MODEL" \
  --arg content "$prompt" \
  '{
    model: $model,
    messages: [{role:"user", content:$content}],
    stream: false,
    options: {temperature: 0, num_predict: 400}
  }')"

docker run --rm --network "$DOCKER_NET" curlimages/curl:8.5.0 -sS \
  -H 'Content-Type: application/json' \
  -d "$payload" \
  "${OLLAMA_BASE_URL}/api/chat" \
  | jq -r '.message.content // .response // empty' >"$analysis_md.tmp"

if [[ ! -s "$analysis_md.tmp" ]]; then
  echo "Error: empty analysis (Ollama produced no output). See report: $report_txt" >&2
  exit 1
fi

{
  # Command substitution strips trailing newlines; force one so the next section starts on a new line.
  printf "%s\n" "$analysis_header"
  cat "$analysis_md.tmp"
  printf "\n"
} >"$analysis_md"
rm -f "$analysis_md.tmp"

# Enforce presence of "Final comment" and model mention.
if ! rg -q -i '^[* ]*final comment' "$analysis_md"; then
  # Deterministic fallback using computed metrics.
  succ="$(jq -r '.success' "$report_json")"
  thr="$(jq -r '.throughput' "$report_json")"
  p95ms="$(jq -r '.latencies["95th"] / 1e6' "$report_json")"
  {
    echo
    echo "**Final comment**"
    printf "Tested model %s: success=%s, throughput=%.2f req/s, p95=%.2f ms. To increase stress, raise rate/duration and observe when throughput flattens or errors appear.\n" \
      "$BENCH_MODEL" "$succ" "$thr" "$p95ms"
  } >>"$analysis_md"
else
  # Avoid duplicating "Final comment" if the model already produced it.
  true
fi

if ! rg -q -F "$BENCH_MODEL" "$analysis_md"; then
  # Ensure model name is always present even if the LLM omits it.
  printf "\nNote: benchmark model = %s\n" "$BENCH_MODEL" >>"$analysis_md"
fi

# If the model outputs multiple "Final comment" sections (or we appended a fallback),
# keep only the first one to guarantee a single final comment.
awk 'BEGIN{cf=0}
{
  line=tolower($0)
  if (line ~ /^[* ]*final comment[* ]*$/) {
    cf++
    if (cf > 1) exit
  }
  print
}' "$analysis_md" >"$analysis_md.dedup"
mv "$analysis_md.dedup" "$analysis_md"

rm -f "$targets" "$body" 2>/dev/null || true

echo "Analysis saved to: $analysis_md"
echo "Report directory: $run_dir"
echo "Files kept:"
echo "  $meta"
echo "  $results"
echo "  $report_txt"
echo "  $report_json"
echo "  $analysis_md"

echo
echo "=== Report (vegeta.report.txt) ==="
cat "$report_txt"

echo
if [[ -t 0 && -t 1 ]]; then
  read -n 1 -s -r -p "Press any key to view the analysis..." _
  echo
else
  echo "Non-interactive STDIN/STDOUT: skipping pause and showing analysis."
fi

echo "=== Analysis (vegeta.analysis.md) ==="
cat "$analysis_md"
