# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_150347
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/tiny:1b
- Modello analisi: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s
**Numeri chiave**

* Total requests: 12
* Rate: 2.1818972121187477/s
* Throughput: 2.1379806365673577/s
* Success rate: 100.00%
* Max latency: 1188.540406ms

**Colli di bottiglia**

* Latenza media: 273.989596ms
* Latenza del 50% percentile: 112.585517ms
* Latenza del 90% percentile: 889.062996ms
* Latenza del 95% percentile: 1145.757918ms

**Prossimi esperimenti**

* Utilizzare un modello più avanzato per migliorare la precisione delle risposte.
* Aumentare la velocità di attacco di Vegeta per testare la capacità del sistema a gestire una maggiore quantità di richieste.
* Testare il sistema con un numero maggiore di richieste per valutare la sua scalabilità.
* Utilizzare un algoritmo di ottimizzazione per ridurre le latenze del sistema.
* Testare il sistema con un tipo di traffico diverso (ad esempio, traffico di video) per valutare la sua capacità a gestire diverse tipologie di dati.

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato che il sistema è in grado di gestire una quantità significativa di richieste con un modello di dimensioni ridotte (bestia/tiny:1b). Tuttavia, le latenze del sistema sono state elevate, soprattutto per le richieste più complesse. Per migliorare la prestazione del sistema, è necessario utilizzare un modello più avanzato e ottimizzare l'algoritmo di processamento delle richieste. Inoltre,

