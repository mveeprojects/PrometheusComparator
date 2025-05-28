#!/bin/bash

function compareLocalJson() {
  colordiff <(jq --sort-keys . $1) <(jq --sort-keys . $2)
}

function comparePrometheus() {

  echo "Comparing Prometheus A and B targets configuration (/api/v1/targets)..."
  callAndCompare "/api/v1/targets"

  echo "Comparing Prometheus A and B alerts (/api/v1/alerts)..."
  callAndCompare "/api/v1/alerts"

  echo "Comparing Prometheus A and B config (/api/v1/status/config)..."
  callAndCompare "/api/v1/status/config"

  echo "Comparing Prometheus A and B rules (/api/v1/rules)..."
  callAndCompare "/api/v1/rules"

  echo "Comparing Prometheus A and B metadata (/api/v1/metadata)..."
  callAndCompare "/api/v1/metadata"
}

function callAndCompare() {
  prometheus_A_Result=$(curl -sb -H "Accept: application/json" "http://localhost:9090$1" | jq --sort-keys '.')
  prometheus_B_Result=$(curl -sb -H "Accept: application/json" "http://localhost:9091$1" | jq --sort-keys '.')
  colordiff  <(echo "$prometheus_A_Result" ) <(echo "$prometheus_B_Result")
}

function errorAndExit() {
    echo "Invalid first argument. Use 'localjson' for local JSON files or 'prometheus' for Prometheus API comparison."
    echo "Usage: $0 <localjson|prometheus> <file1|url1> <file2|url2>"
    echo "Example: $0 localjson resources/json/A.json resources/json/B.json"
    echo "Example: $0 prometheus http://localhost:9090 http://localhost:9091"
    exit 1
}

if [[ ! -z $1 && ! -z $2 && ! -z $3 ]]; then
  if [[ $1 == "localjson" ]]; then
    compareLocalJson "$2" "$3"
  elif [[ $1 == "prometheus" ]]; then
    comparePrometheus "$2" "$3"
  else
    errorAndExit
  fi
else
  errorAndExit
fi
