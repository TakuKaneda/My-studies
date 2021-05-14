# gRPC

Follow https://grpc.io/docs/languages/go/quickstart/

Install protocol buffer

```zsh
brew install protobuf
```

Install Go plugins

```zsh
export GO111MODULE=on
go get google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
# Update path
export PATH="$PATH:$(go env GOPATH)/bin"
```
