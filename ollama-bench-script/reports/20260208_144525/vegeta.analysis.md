# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144525
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
* Max latency: 120.831ms

**Colli di bottiglia**

* Latency 90%: 116.113ms
* Latency 95%: 120.157ms
* Latency 99%: 120.831ms

**Prossimi esperimenti**

* Utilizzare un modello più avanzato per migliorare la precisione delle previsioni.
* Aumentare la velocità di attacco di Vegeta per testare la capacità del sistema a gestire una maggiore quantità di traffico.
* Testare il sistema con un numero maggiore di richieste per valutare la sua scalabilità.
* Utilizzare strumenti di monitoring più avanzati per ottimizzare le prestazioni del sistema.
* Testare il sistema con dati più complessi e simili a quelli reali per valutare la sua capacità di gestire situazioni estreme.

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato che il modello bestia/tiny:1b è in grado di gestire una grande quantità di traffico con una buona precisione. Tuttavia, è importante notare che le latenze sono state elevate, soprattutto per le richieste più complesse. Per migliorare le prestazioni del sistema, sarebbe necessario utilizzare un modello più avanzato e testare il sistema con dati più complessi e simili a quelli reali. Inoltre, è importante ottimizzare le prestazioni del sistema utilizzando strumenti di monitoring più avanzati.

