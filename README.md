# ollama-bench

This repository contains a small, self-contained benchmark runner to stress test a local Ollama instance using Vegeta, save the results, and generate a short performance commentary using Ollama itself.

## What it does
- Lists the available Ollama models and lets you pick the benchmark model.
- Asks for a stress level (1-10) and maps it to Vegeta `rate` and `duration`.
- Runs a Vegeta attack against `POST /api/chat` and writes results to disk.
- Generates:
  - a Vegeta text report
  - a Vegeta JSON report
  - an analysis markdown file produced by Ollama (with a guaranteed final comment and model name)
- Prints the report to the terminal, waits for a keypress, then prints the analysis.

## Prerequisites
- Docker (the script uses `peterevans/vegeta` and `curlimages/curl` containers)
- An Ollama container reachable from a Docker network (default: `nuvolaris-ollama`) as `http://ollama:11434`
- `jq` and `rg` installed on the host

## Usage
Run the script:

```bash
cd ollama-bench-script
./stress_ollama.sh
```

Artifacts for each run are stored under:

`ollama-bench-script/reports/<timestamp>/`

Each run directory contains:
- `meta.json`
- `vegeta.gob`
- `vegeta.report.txt`
- `vegeta.report.json`
- `vegeta.analysis.md`

## Specs and log
- Requirements/specification: `ollama-bench-script/stress_ollama.spec`
- Execution notes/log: `AGENT.MD`

## Configuration
You can override defaults via environment variables:
- `DOCKER_NET` (default: `nuvolaris-ollama`)
- `OLLAMA_BASE_URL` (default: `http://ollama:11434`)
- `BENCH_MODEL` (default: `bestia/tiny:1b`, used if you just press Enter at the model prompt)
- `ANALYSIS_MODEL` (default: `bestia/small:3b`)
