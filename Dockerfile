# Build the application from source
FROM golang:1.19 AS build-stage

WORKDIR /app

COPY . .

RUN go mod init
RUN GOOS=linux go build -o goviolin .

# Multi-stage
# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /app

COPY --from=build-stage /app .

EXPOSE 8080 
CMD ["./goviolin"]