FROM golang:1.19.6-buster AS build

WORKDIR /app
# configmaps - pod/golang
COPY go.mod ./ 
COPY go.sum ./
# exec command
RUN go mod download && go mod verify
# configmap - pod/golang
COPY main.go main.go
# exec command
RUN go build -o /myapp main.go

FROM gcr.io/distroless/base-debian11

COPY --from=build /myapp /myapp
# entry exec command
ENTRYPOINT ["/myapp"]