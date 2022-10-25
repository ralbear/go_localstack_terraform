#!/bin/bash

path = $1

if

for package in ls $1
do
	CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags "-s -w" -o ./bin/main ./cmd/$package/*.go
	zip -r -j ./bin/api_get_grettings.zip ./bin/main
	rm ./bin/main
done

