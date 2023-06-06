# Build the application from source
FROM golang:1.19 

WORKDIR /app

COPY . .
RUN go mod init
RUN go build -o goviolin .

EXPOSE 8080 
CMD ["./goviolin"]