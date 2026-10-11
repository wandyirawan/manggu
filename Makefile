.PHONY: run build test vet fmt tidy

run:
	MANGGU_DB_DSN=file:./manggu.db go run ./cmd/api

build:
	go build -o bin/api ./cmd/api

test:
	go test ./...

vet:
	go vet ./...

fmt:
	gofmt -l -w .

tidy:
	go mod tidy

sqlc:
	sqlc generate
