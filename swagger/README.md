# Tutorial for OpenAPI 3.0 code generator

https://future-architect.github.io/articles/20200701/

```zsh
# set path
export PATH="$PATH:$(go env GOPATH)/bin"
# download yaml
curl https://raw.githubusercontent.com/deepmap/oapi-codegen/master/examples/petstore-expanded/petstore-expanded.yaml -o openapi.yaml
# get module
go get github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.3.8
# run code generatoin from yaml
oapi-codegen openapi.yaml > openapi.gen.go
# install packages
go mod init openapi-tutorial
go mod tidy
```
