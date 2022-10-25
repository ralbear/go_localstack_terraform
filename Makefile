build:
	ifndef $(function)
		@echo "function parameter is required"
		exit 1
	endif

	CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags "-s -w" -o ./bin/main "./cmd/$(function)/*.go"
	zip -r -j "./bin/$(function).zip" ./bin/main
	rm ./bin/main

terraform-plan:
	terraform -chdir=./terraform plan -var-file=../variables.tfvars

terraform-apply:
	terraform -chdir=./terraform apply -var-file=../variables.tfvars -auto-approve

terraform-destroy:
	terraform -chdir=./terraform destroy -var-file=../variables.tfvars

build-and-deploy:
	$(MAKE) build
	$(MAKE) terraform-apply
