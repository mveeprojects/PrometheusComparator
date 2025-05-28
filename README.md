# PrometheusComparator
Tool to compare two prometheus instances to ensure they have the same metrics, alerts, config etc.

Using [cAdvisor](https://github.com/google/cadvisor) as a prometheus scrape target.

### Prerequisites

* Install colordiff ([ref](https://stackoverflow.com/a/8800636/3059314])):
  * Ubuntu/Debian: `sudo apt-get install colordiff`
  * OS X: `brew install colordiff` or `port install colordiff`

### Runninn the example locally

Run cAdvisor and prometheus containers using docker compose:
```shell
docker compose down && docker compose up -d
````

To check local json files (in resources/json/):
```shell
./compare.sh localjson resources/json/A.json resources/json/B.json
```

Or to check two prometheus instances:
```shell
./compare.sh prometheus http:localhost:9090 http://localhost:9091
```

### Example output 

```shell
./compare.sh prometheus http://localhost:9090 http://localhost:9091
Comparing Prometheus A and B targets configuration (/api/v1/targets)...
20,21c20,21
<         "lastScrape": "2025-05-28T23:05:44.540038214Z",
<         "lastScrapeDuration": 0.018338125,
---
>         "lastScrape": "2025-05-28T23:05:50.777035883Z",
>         "lastScrapeDuration": 0.014861542,
Comparing Prometheus A and B alerts (/api/v1/alerts)...
Comparing Prometheus A and B config (/api/v1/status/config)...
Comparing Prometheus A and B rules (/api/v1/rules)...
Comparing Prometheus A and B metadata (/api/v1/metadata)...
```


### Sources
* [Medium: Docker Container Monitoring with cAdvisor, Prometheus, and Grafana using Docker Compose](https://medium.com/@sohammohite/docker-container-monitoring-with-cadvisor-prometheus-and-grafana-using-docker-compose-b47ec78efbc).
* [SO: Using jq or alternative command line tools to compare JSON files](https://stackoverflow.com/a/37175540/3059314).
* [SO: How to colorize diff on the command line](https://stackoverflow.com/a/8800636/3059314).
* [SO: What does 1c1 in diff tool mean?](https://stackoverflow.com/a/20255621/3059314).