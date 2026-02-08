Title: Ollama Vegeta Stress Test + Report Analysis
Date: 2026-02-08

Scope
- Create a repeatable stress test runner for a locally installed Ollama reachable from Docker.
- Use Vegeta (docker image) to generate load and save results.
- Use Ollama itself to comment on the performance report.
- Keep the workspace tidy and organized.

Environment Assumptions
- Ollama runs in Docker and is reachable in the Docker network `nuvolaris-ollama` as `http://ollama:11434`.
- Vegeta is executed via the `peterevans/vegeta` Docker image.
- `jq` and `rg` are available on the host.

Functional Requirements
1) Fix Vegeta invocation for Ollama
  - Use `vegeta attack -targets=...` (not `-targets-file`).
  - Call a real Ollama endpoint (recommended: `POST /api/chat`) with JSON body and headers.
  - Save both raw results (gob) and reports (txt + json).

2) User-driven stress level
  - Prompt the user to select a stress level from 1 to 10.
  - Map the chosen level to Vegeta settings (rate/duration/timeout) in a deterministic way.

3) User model selection from available models
  - Query Ollama model list from `GET /api/tags`.
  - Present the list to the user.
  - Allow selecting the benchmark model by either:
    - index number from the list, or
    - exact model name.

4) Generate the request material for the benchmark
  - Generate a Vegeta targets file pointing to Ollama (`/api/chat`).
  - Generate a JSON request body for Ollama that includes:
    - selected benchmark model
    - `stream: false`
    - conservative options for repeatability (e.g. temperature 0, low num_predict)

5) Report and analysis
  - Run Vegeta and generate:
    - `vegeta.gob`
    - `vegeta.report.txt`
    - `vegeta.report.json`
  - Read the report(s) and ask Ollama to comment on them.
  - The analysis output must always include:
    - the benchmark model name
    - a final section named `Final comment`

6) Keep files in order
  - Create a folder `ollama-bench-script/reports/`.
  - Store each run under `ollama-bench-script/reports/<timestamp>/`.
  - Keep only the useful artifacts per run:
    - meta.json (run metadata)
    - vegeta.gob
    - vegeta.report.txt
    - vegeta.report.json
    - vegeta.analysis.md
  - Delete non-essential generated files at the end of each run (targets/body).
  - When reorganizing the folder, move legacy scattered run files into the `reports/<timestamp>/` structure.

7) Visibility of results
  - At the end of the stress test:
    - print the report with `cat`
    - pause and wait for a keypress
    - print the analysis with `cat`

Operational Requirement (traceability)
- Keep a human-readable log of executed operations in `AGENT.MD` at the repository root.

Implementation Notes (current implementation)
- Script: `ollama-bench-script/stress_ollama.sh`
- Reports: `ollama-bench-script/reports/<timestamp>/`
  - meta.json
  - vegeta.gob
  - vegeta.report.txt
  - vegeta.report.json
  - vegeta.analysis.md
