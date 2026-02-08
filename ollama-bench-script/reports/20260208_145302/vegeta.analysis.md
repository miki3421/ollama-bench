# Analisi stress test Ollama (Vegeta)

- Timestamp: 20260208_145302
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Modello testato: bestia/reasoning:20b
- Modello analisi: bestia/small:3b
- Vegeta rate: 10/s
- Vegeta duration: 10s
- Timeout: 180s
**Numeri chiave**

* Velocità di attacco di Vegeta: 10/s
* Durata dell'attacco di Vegeta: 10s
* Timeout: 180s
* Successo del test: 100%
* Errore: 0

**Colli di bottiglia**

* Latenza media: 26.17s
* Latenza massima: 35.642s
* Attesa media: 35.294s
* Consumo di byte in: 43469
* Consumo di byte usciti: 18400

**Prossimi esperimenti**

* Aumentare la velocità di attacco di Vegeta
* Ridurre il timeout
* Aggiungere un nuovo modello per migliorare le prestazioni
* Testare con una maggiore quantità di dati
* Utilizzare un algoritmo di ottimizzazione per trovare l'ottimo valore dei parametri

**Commento finale**

Il test di Vegeta contro Ollama ha dimostrato che il modello bestia/reasoning:20b è in grado di gestire una grande quantità di dati e di affrontare attacchi veloci senza problemi. Tuttavia, le latenze medie sono ancora elevate e potrebbero essere ottimizzate utilizzando tecniche di ottimizzazione avanzate. In futuro, sarà importante testare il modello con una maggiore quantità di dati e utilizzare algoritmi di ottimizzazione per trovare l'ottimo valore dei parametri.


