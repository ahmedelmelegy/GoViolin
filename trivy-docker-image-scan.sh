#!/bin/bash

echo $imageName #getting Image name from env variable

docker run --rm -v $HOME/Library/Cache:/root/.cache/ -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.17.2 -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $imageName > trivy_scan_results.txt
docker run --rm -v $HOME/Library/Cache:/root/.cache/ -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $imageName >> trivy_scan_results.txt

    # Trivy scan result processing
    exit_code=$?
    echo "Exit Code : $exit_code"

    # Check scan results
    if [[ ${exit_code} == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found"
        exit 1;
    else
        echo "Image scanning passed. No vulnerabilities found"
    fi;