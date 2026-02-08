# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_144349
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/tiny:1b
- Modello analisi: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s
**Numeri chiave**

* Total requests: 12
* Rate: 2.1817785579427604/s
* Throughput: 2.138469755583665 req/s
* Success ratio: 100.00%
* Max latency: 122.447615ms

**Colli di bottiglia**

* Latenza media: 114.767ms (oltre il limite di attesa di 180s)
* Latenza massima: 122.447615ms (superiore al limite di latenza previsto)
* Attesa media: 111.389ms (oltre il limite di attesa di 180s)

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta per testare la tolleranza del sistema
* Ridurre la durata dell'attacco di Vegeta per testare la capacità di risposta del sistema
* Aggiungere ulteriori colli di bottiglia, come ad esempio la gestione delle eccezioni o le query più complesse
* Testare il sistema con un modello diverso, come ad esempio bestia/medium:1b
* Utilizzare una rete di test più grande per testare la scalabilità del sistema

**Commento finale**

Il test di Vegeta contro Ollama ha evidenziato alcuni colli di bottiglia significativi, come la latenza media e massima elevate. Tuttavia, il modello utilizzato (bestia/tiny:1b) sembra aver tollerato bene le condizioni di attacco. Per migliorare ulteriormente le prestazioni del sistema, è necessario testare ulteriori scenari e aumentare la velocità di attacco di Vegeta. Inoltre, è importante considerare l'aggiunta di eccezioni e query più complesse

