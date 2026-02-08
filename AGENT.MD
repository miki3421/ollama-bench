# Operazioni eseguite (2026-02-08)

## Contesto
- Obiettivo: sistemare il comando `docker run ... vegeta attack | vegeta report` per fare uno stress test contro Ollama in Docker.
- Ambiente rilevato: container `ollama` (image `ollama/ollama:0.15.4`) attivo e connesso alla network Docker `nuvolaris-ollama`.

## Diagnosi
1) Ho verificato container e network:
```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker network ls
docker inspect -f '{{json .NetworkSettings.Networks}}' ollama | jq .
docker network inspect nuvolaris-ollama --format '{{json .Containers}}' | jq .
```

2) Ho verificato la sintassi dei flag di Vegeta:
- `vegeta attack` usa `-targets` (non `-targets-file`).
```bash
docker run --rm peterevans/vegeta vegeta attack -h
```

3) Ho verificato che l’API di Ollama risponda dentro la stessa network:
```bash
docker run --rm --network nuvolaris-ollama curlimages/curl:8.5.0 -sS http://ollama:11434/api/version
docker run --rm --network nuvolaris-ollama curlimages/curl:8.5.0 -sS http://ollama:11434/api/tags
```

## Fix applicato
### File usati
Ho creato un `targets.txt` minimale (solo metodo+URL) e un `body.json` separato, per evitare problemi di parsing del body inline nel formato `http` di Vegeta.

```bash
cat > /home/michele/targets.txt <<'EOT'
POST http://ollama:11434/api/chat
EOT

cat > /home/michele/body.json <<'EOT'
{"model":"bestia/tiny:1b","messages":[{"role":"user","content":"ping"}],"stream":false}
EOT
```

### Comando funzionante (attack + report)
```bash
docker run --rm \
  --network nuvolaris-ollama \
  -v "$PWD/targets.txt:/tmp/targets.txt:ro" \
  -v "$PWD/body.json:/tmp/body.json:ro" \
  peterevans/vegeta sh -lc \
  'vegeta attack \
     -targets=/tmp/targets.txt \
     -rate=1/s \
     -duration=5s \
     -timeout=120s \
     -header="Content-Type: application/json" \
     -header="Accept: application/json" \
     -body=/tmp/body.json \
   | vegeta report'
```

## Esecuzione
Ho eseguito il comando sopra e ho ottenuto un report con `Success 100%` su 5 richieste (rate 1/s, durata 5s).

## Esecuzione con output su file (2026-02-08)
Per non perdere i risultati (che altrimenti finiscono su stdout), ho rilanciato Vegeta salvando:
- risultati grezzi: `/home/michele/ollama-bench/vegeta_20260208_142926.gob`
- report testuale: `/home/michele/ollama-bench/vegeta_20260208_142926.report.txt`
- report JSON: `/home/michele/ollama-bench/vegeta_20260208_142926.report.json`

Comando usato (stesso test, con `-output` e redirect dei report):
```bash
docker run --rm \
  --network nuvolaris-ollama \
  -v "$PWD/targets.txt:/tmp/targets.txt:ro" \
  -v "$PWD/body.json:/tmp/body.json:ro" \
  -v "/home/michele/ollama-bench:/out" \
  peterevans/vegeta sh -lc \
  "vegeta attack -targets=/tmp/targets.txt -rate=1/s -duration=5s -timeout=120s \
     -header='Content-Type: application/json' -header='Accept: application/json' \
     -body=/tmp/body.json -output=/out/vegeta_20260208_142926.gob && \
   vegeta report /out/vegeta_20260208_142926.gob > /out/vegeta_20260208_142926.report.txt && \
   vegeta report --type=json /out/vegeta_20260208_142926.gob > /out/vegeta_20260208_142926.report.json"
```

## Repository Updates (2026-02-08)
- Created the benchmark runner in `ollama-bench-script/stress_ollama.sh`.
- Organized runs under `ollama-bench-script/reports/<timestamp>/` and removed per-run temporary request files (`targets.txt`, `body.json`) after each execution.
- Added `ollama-bench-script/stress_ollama.spec` to capture all requirements.
- Updated `README.md` (English) with usage and artifact locations.
- Translated the whole script to English (prompts, messages, analysis headings).
- Updated end-of-run UX: print report with `cat`, pause for a keypress, then print the analysis with `cat`.
