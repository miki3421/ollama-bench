**Risultati del stress test Vegeta contro Ollama**

Il test ha avuto un successo limitato, con alcuni risultati interessanti che meritano di essere analizzati.

**Output richiesto:**

* **Throughput:** 2.14 requests/s è un valore ragionevole per il modello bestia/tiny:1b e la configurazione di endpoint.
* **Latenza p50/p95/p99:** La latenza media (114.823ms) è un po' alta rispetto alle aspettative, ma la latenza 90% (118.944ms) e la latenza 95% (121.041ms) sono ancora ragionevoli.
* **Errori:** Nessun errore è stato segnalato durante il test.

**Colli di bottiglia probabili:**

1. **Sottodimensionamento della rete**: La configurazione di Docker network "nuvolaris-ollama" potrebbe non essere ottimizzata per supportare il traffico massivo richiesto dal test.
2. **Limitazioni del modello**: Il modello bestia/tiny:1b potrebbe non essere adatto per applicazioni che richiedono un alto livello di precisione e velocità.
3. **Congestione dei server**: La configurazione di endpoint "http://ollama:11434/api/chat" potrebbe essere soggetta a congestioni, specialmente se il test viene eseguito con una grande quantità di utenti.

**Azioni/esperimenti successivi:**

1. **Aumentare la velocità di rilascio**: Aumentare la velocità di rilascio (rate) del test per vedere se ci sono miglioramenti nella latenza e nell'efficienza.
2. **Cambiare il modello**: Sperimentare con altri modelli, come
