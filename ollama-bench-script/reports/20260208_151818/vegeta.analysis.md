# Ollama Stress Test Analysis (Vegeta)

- Timestamp: 20260208_151818
- Endpoint: http://ollama:11434/api/chat
- Docker network: nuvolaris-ollama
- Benchmark model: bestia/tiny:1b
- Analysis model: bestia/small:3b
- Vegeta rate: 2/s
- Vegeta duration: 6s
- Timeout: 180s
**Key Metrics**

• Requests: 12
• Rate: 2.1818110294449347/s
• Throughput: 2.1391189854458554 requests/s
• Success Ratio: 100.00%
• Status Codes (200): 12

**Bottlenecks**

• High latency values, with the maximum value being 982.27ms and the 90th percentile at 681.492ms
• High wait times, with an average of 109.768ms
• High bytes out values, with a total of 2136 and a mean of 178

**Next Experiments**

• Increase the rate to see how the system scales under higher loads
• Decrease the duration to test the system's responsiveness under shorter time constraints
• Test different models or configurations to compare their performance against the bestia/tiny:1b model
• Investigate the cause of high bytes out values and optimize the system accordingly
• Run stress tests with a larger number of requests to further evaluate the system's capacity

**Final comment**
The results of this stress test on the Ollama API using the bestia/tiny:1b model indicate that the system is capable of handling moderate loads, but may require optimization for higher loads or more demanding use cases. Further investigation into the high latency and bytes out values is necessary to ensure the system's performance meets expectations.

