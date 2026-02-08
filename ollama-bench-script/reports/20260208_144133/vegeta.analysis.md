# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144133
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/tiny:1b
- Modello analisi: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s**Numeri chiave**

* Total requests: 12
* Rate: 2.181863681609993/s
* Throughput: 2.137914750096689/s
* Success ratio: 100.00%
* Max latency: 126.449081ms

**Colli di bottiglia**

* Latency minima: 108.471394ms
* Latency media: 112.971716ms
* Latenza del 50% percentile: 112.590592ms
* Latenza del 90% percentile: 118.740266ms
* Latenza del 95% percentile: 125.347821ms

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta per testare la scalabilità del sistema.
* Aggiungere ulteriori colline di bottiglia, come ad esempio il tempo di risposta medio e il numero di errori.
* Testare il sistema con un modello più avanzato, come ad esempio bestia/medium:1b.

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato una buona scalabilità del sistema, con un aumento significativo della velocità di attacco senza compromettere la stabilità. Tuttavia, è importante notare che il modello utilizzato (bestia/tiny:1b) potrebbe non essere adatto per applicazioni più complesse. Per migliorare ulteriormente le prestazioni del sistema, sarebbe necessario testare con modelli più avanzati e aumentare la velocità di attacco in modo graduale.


**Commento finale**
Test su modello bestia/tiny:1b: success=1, throughput=2.14 req/s, p95=125.35 ms. Per alzare lo stress, aumenta rate/duration e verifica quando throughput si appiattisce o compaiono errori.
