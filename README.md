# GoViolin

GoViolin is a web app written in Go that helps with violin practice.

Currently hosted on Heroku at https://go-violin.herokuapp.com/

GoViolin allows practice over both 1 and 2 octaves.

Contains:
* Major Scales
* Harmonic and Melodic Minor scales
* Arpeggios
* A set of two part scale duet melodies by Franz Wohlfahrt
## built singlestage docker image
FROM golang:1.19 

WORKDIR /app

COPY . .
RUN go mod init
RUN go build -o goviolin .

EXPOSE 8080 
CMD ["./goviolin"]
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/e70dbe74-c844-4490-987d-0f5d43591adf)
But as you can see the size of the image is very big

After I ran this image
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/70624f26-1127-4e42-bc61-9b9772c226c2)

## built multi-stage docker image to reduce size
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
![image](https://github.com/ahmedelmelegy/GoViolin/assets/62904201/30fe4bd6-948c-4726-8903-4a16876b215d)

