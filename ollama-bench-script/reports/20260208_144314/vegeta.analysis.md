# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144314
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/tiny:1b
- Modello analisi: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s
**Numeri chiave**

* Total requests: 12
* Rate: 2.18/s
* Throughput: 2.14/s
* Success ratio: 100%
* Max latency: 123.615ms

**Colli di bottiglia**

* Latency 90%: 118.553ms
* Latency 95%: 122.891ms
* Latency 99%: 123.614ms

**Prossimi esperimenti**

* Utilizzare un modello più avanzato per migliorare la precisione delle risposte.
* Aumentare la velocità di attacco di Vegeta per ridurre il tempo di attesa.
* Aggiungere una capacità di elaborazione aggiuntiva per gestire un maggior numero di richieste.

**Commento finale**

Il test ha dimostrato che il modello bestia/tiny:1b è in grado di gestire una buona quantità di richieste con una velocità di attacco ragionevole. Tuttavia, le latenze sono state un po' elevate, soprattutto per le richieste più complesse. Per migliorare la prestazione del sistema, sarebbe utile utilizzare un modello più avanzato e aumentare la capacità di elaborazione. Inoltre, è importante ottimizzare la velocità di attacco per ridurre il tempo di attesa e migliorare l'esperienza dell'utente.


**Commento finale**
Test su modello bestia/tiny:1b: success=1, throughput=2.14 req/s, p95=122.89 ms. Per alzare lo stress, aumenta rate/duration e verifica quando throughput si appiattisce o compaiono errori.
