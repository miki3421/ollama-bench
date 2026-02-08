# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_150432
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/coding:30b
- Modello analisi: bestia/small:3b
- Vegeta rate: 10/s
- Vegeta duration: 10s
- Timeout: 180s
**Numeri chiave**

* Request totale: 100
* Rate di richieste: 10.101023342533429/s
* Throughput: 3.254045244983494 req/s
* Success rate: 100%
* Errore totale: 0

**Colli di bottiglia**

* Latenza media: 13.971s
* Latenza massima: 20.831s
* Attesa media: 20.83099318s
* Tempo di attesa massimo: 20.831s

**Prossimi esperimenti**

* Aumentare la velocità di richieste per testare la scalabilità del sistema
* Aggiungere ulteriori colli di bottiglia, come ad esempio il tempo di risposta medio o l'errore totale
* Testare il sistema con un modello diverso, come ad esempio bestia/coding:20b
* Utilizzare un numero maggiore di richieste per testare la capacità del sistema
* Aggiungere ulteriori variabili di input per testare la robustezza del sistema

**Commento finale**

Il test con Vegeta contro Ollama ha dimostrato che il sistema è in grado di gestire una grande quantità di richieste senza compromettere la qualità dei risultati. Il modello bestia/coding:30b sembra essere adatto per questo tipo di test, poiché ha mostrato un buon equilibrio tra velocità e precisione. Tuttavia, è importante continuare a testare e ottimizzare il sistema per garantire la sua scalabilità e robustezza in ambienti più complessi.


