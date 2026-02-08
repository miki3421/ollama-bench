# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144209
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
* Latency max: 122.986ms
* Bytes In total: 5004
* Bytes Out total: 2136

**Colli di bottiglia**

* Latenza media: 113.324ms (leggermente superiore al limite di attesa)
* Latenza p50: 111.767ms (molto vicino alla latenza media)
* Latenza p95: 122.782ms (superiore alla latenza media)

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta per testare la tolleranza del sistema
* Aggiungere ulteriori colline di bottiglia testando la latenza con una maggiore variazione
* Testare il sistema con un numero maggiore di richieste per valutare la scalabilità
* Utilizzare un modello diverso (ad esempio bestia/medium:1b) per vedere se ottimizza le prestazioni
* Aggiungere ulteriori errori al sistema per testare la tolleranza del sistema

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato che il sistema è in grado di gestire una velocità di attacco relativamente alta, ma che le latenze possono essere un problema. Il modello utilizzato (bestia/tiny:1b) sembra aver contribuito a ottimizzare le prestazioni, ma è importante testare ulteriormente per confermare questi risultati. In futuro, sarà necessario testare il sistema con una maggiore variazione di latenza e errori per valutare la tolleranza del sistema.


**Commento finale**
Test su modello bestia/tiny:1b: success=1, throughput=2.14 req/s, p95=122.78 ms. Per alzare lo stress, aumenta rate/duration e verifica quando throughput si appiattisce o compaiono errori.
