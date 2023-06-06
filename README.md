# GoViolin

GoViolin is a web app written in Go that is dockerized, automated using jenkins and deployed in minikube that helps with violin practice.
GoViolin allows practice over both 1 and 2 octaves.

Contains:

- Major Scales
- Harmonic and Melodic Minor scales
Arpeggios
- A set of two part scale duet melodies by Franz Wohlfahrt
- Dockerfile
- Jenkinsfile
- kubernetes files

## Prerequistis

- Docker
- Jenkins
- Minikube

## How to build this app

```bash
go build -o goviolin .
```
This will produce an artifiact called goviolin then to run it
```bash
./goviolin
```
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/70624f26-1127-4e42-bc61-9b9772c226c2)
## Dockerize application
### Single-Stage Dockerfile

```bash
FROM golang:1.19

WORKDIR /app

COPY . . RUN go mod init RUN go build -o goviolin .

EXPOSE 8080 CMD ["./goviolin"]
```
To build image
```bash
docker build . -t goviolin-multistage
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
To run container with the built image, we will map port 8080 from host to port 8080 in the container
```bash
docker run -p 8080:8080 goviolin-multistage
```
