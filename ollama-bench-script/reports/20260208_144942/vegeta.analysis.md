# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144942
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
* Latency max: 125.575ms
* Bytes In total: 5004

**Colli di bottiglia**

* Latenza media: 115.14ms (oltre il limite di attesa di 109.831ms)
* Latenza p95: 124.957ms (oltre il limite di attesa di 109.831ms)
* Latenza p99: 125.575ms (oltre il limite di attesa di 109.831ms)

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta per ridurre le latenze
* Ridurre la durata dell'attacco di Vegeta per migliorare la throughput
* Utilizzare un modello più veloce, come bestia/medium:1b
* Aggiungere una capacità di buffering per ridurre le latenze
* Utilizzare un algoritmo di compressione per ridurre il numero di byte In

**Commento finale**

Il test ha dimostrato che il modello bestia/tiny:1b è in grado di gestire una grande quantità di request con una velocità di attacco relativamente bassa. Tuttavia, le latenze sono state elevate, soprattutto per le latenze p95 e p99. Per migliorare la prestazione del sistema, sarebbe necessario aumentare la velocità di attacco o utilizzare un modello più veloce. Inoltre, è importante considerare l'aggiunta di una capacità di buffering e l'utilizzo di un algoritmo di compressione per ridurre le latenze e migliorare la throughput.

