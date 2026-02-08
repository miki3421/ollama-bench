# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144239
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/tiny:1b
- Modello analisi: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s
**Numeri chiave**

* Total requests: 12
* Rate: 2.1817665334540624/s
* Throughput: 2.1384397007591796/s
* Success ratio: 100.00%
* Max latency: 123.446598ms

**Colli di bottiglia**

* Latenza media: 113.353ms (leggermente superiore al modello bestia/tiny:1b)
* Latenza massima: 123.447ms
* Attesa media: 111.437896ms (molto breve)

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta per testare la tolleranza del modello a flussi di traffico più intensi.
* Aggiungere ulteriori colli di bottiglia, come ad esempio il tempo di risposta dei servizi di rete o le latenze dei server.
* Testare il modello con un numero maggiore di richieste per valutare la sua capacità di gestione del carico.

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato che il modello bestia/tiny:1b è in grado di gestire flussi di traffico moderati, ma potrebbe essere soggetto a colli di bottiglia se la velocità di attacco aumenta. Per migliorare le prestazioni del modello, sarebbe necessario testare ulteriormente con diverse configurazioni e aumentare la tolleranza al carico.


**Commento finale**
Test su modello bestia/tiny:1b: success=1, throughput=2.14 req/s, p95=122.50 ms. Per alzare lo stress, aumenta rate/duration e verifica quando throughput si appiattisce o compaiono errori.
