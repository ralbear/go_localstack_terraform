# Colours used in help
RED      := $(shell tput -Txterm setaf 1)
GREEN    := $(shell tput -Txterm setaf 2)
WHITE    := $(shell tput -Txterm setaf 7)
CYAN     := $(shell tput -Txterm setaf 6)
YELLOW   := $(shell tput -Txterm setaf 3)
RESET    := $(shell tput -Txterm sgr0)

docker-start:
	docker-compose up -d

docker-stop:
	docker-compose down

build:
	@if [ ! "$(function)" ]; then echo "${RED}function parameter is required${RESET}"; exit 1; fi
	@if [ ! -d "./cmd/$(function)" ]; then echo "${RED}function not found${RESET}"; exit 1; fi

	@echo "${YELLOW} Start building ${function}${RESET}"
	CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -ldflags "-s -w" -o ./bin/main ./cmd/$(function)/*.go
	@echo "${GREEN} Function ${function} build correctly${RESET}"
	zip -r -j "./bin/$(function).zip" ./bin/main
	@echo "${GREEN} zip file created on ./bin/$(function).zip${RESET}"
	rm ./bin/main
	@echo "${GREEN} Build ${function} done ${RESET}"

build-all:
	@for f in $(shell ls ./cmd/); do $(MAKE) build function=$${f}; done
	@echo "${GREEN} All functions build ${RESET}"

terraform-init:
	terraform -chdir=./terraform init

terraform-plan:
	terraform -chdir=./terraform plan -var-file=../variables.tfvars

terraform-apply:
	terraform -chdir=./terraform apply -var-file=../variables.tfvars -auto-approve

terraform-destroy:
	terraform -chdir=./terraform destroy -var-file=../variables.tfvars

setup:
	$(MAKE) docker-start
	$(MAKE) terraform-init

build-and-deploy:
	$(MAKE) build-all
	$(MAKE) terraform-apply
