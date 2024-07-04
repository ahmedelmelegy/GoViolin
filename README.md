# GoViolin

GoViolin is a web app written in Go that helps with violin practice that is dockerized, automated using jenkins and deployed in minikube.
GoViolin allows practice over both 1 and 2 octaves.

## Contents:
- Major Scales
- Harmonic and Melodic Minor scales
Arpeggios
- A set of two part scale duet melodies by Franz Wohlfahrt
- Dockerfile multi-stage
- Makefile
- Jenkinsfile
- kubernetes files
- Helm Charts

## Prerequistis

- Docker
- Trivy (to scan docker image common vulnerabilities)
- Jenkins
- Kind
- Helm

## Objectives

- Create Dockerfile
- Create Jenkinsfile
- kubernetes manifests
- Create local-registery for images
- Connect Kind cluster with local-registry
- Deploy helm charts

## How to build this app

```bash
go build -o goviolin .
```
This will produce an artifiact called goviolin then to run it
```bash
./goviolin
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/5db629ec-02ca-4d61-bc47-557200030ab5)
## Dockerize application
### Single-Stage Dockerfile

```bash
FROM golang:1.19

WORKDIR /app

COPY . . RUN go mod init RUN go build -o goviolin .

EXPOSE 8080
CMD ["./goviolin"]
```
To build image
```bash
docker build . -t goviolin
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/e70dbe74-c844-4490-987d-0f5d43591adf)
The size of the image is more than 1 GB!!!
### Multi-Stage Dockerfile
As we saw single stage Dockerfile generated an image that has very big size and that isn`t effiecient
```bash
FROM golang:1.19 AS build-stage

WORKDIR /app

COPY . .

RUN go mod init
RUN GOOS=linux go build -o goviolin .

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /app

COPY --from=build-stage /app .

EXPOSE 8080 
CMD ["./goviolin"]
```
To build image
```bash
docker build . -t goviolin-multistage
```
What we benifted from that?
The size of the image is greatly reduced
![Screenshot 2023-06-06 211947](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/9e73942e-2e5c-4b76-8b07-056c893d9bb6)
Now it is less than 0.25 GB!

To run container with the built image, we will map port 5000 from host to port 5000 in the container
```bash
docker run --name goviolin -p 8080:8080 -d --rm goviolin-multistage
```
### Makefile
To automate building and running container
```bash
make
```
To stop running container
```bash
make stop_website
```
### Scan Docker image using Trivy
Trivy is used for CVE Common Vulnerabilities and Exposures
```bash
trivy image goviolin-multistage
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/d1a66e59-3a67-4c5c-814c-8799fb68e5b7)

## deploy app on kubernetes cluster
### minkube
``` bash
minikube start
```
Create development namespace
``` bash
kubectl apply -f namespace.yml
```
![Screenshot from 2023-07-26 08-43-25](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/55e1b7ec-dd34-40b8-b129-2411f7af3992)
create deployment with 3 replicas
```bash
kubectl apply -f deployment.yml
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/e9bf3254-814b-4bd7-9494-c629ba32b4d0)
Create loadbalancer service
```bash
kubectl apply -f service.yml
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/b7ee3ba8-ecc7-4130-85fd-6f82b1b036f9)
To access the deployed app in minikube and It will open it directly on the browser
```bash
minikube service demo-service
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/4cdd9c53-dbb5-4fc0-822b-1cba5aea5362)
'''bash
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
'''
