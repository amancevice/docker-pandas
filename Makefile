REPO           := amancevice/pandas
PLATFORM       := linux/amd64
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -Eo '[0-9.]+')
PYTHON_VERSION := $(shell pyenv local)

all: requirements.txt requirements-dev.txt

clean:
	-pipenv --rm
	-docker image rm --force $(shell docker image ls --quiet $(REPO) | uniq | xargs)

push:
	docker push --all-tags $(REPO)

Dockerfile: requirements.txt
	docker buildx build --load --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --platform $(PLATFORM) --tag $(REPO) --tag $(REPO):$(PANDAS_VERSION) .

Dockerfile.%: requirements.txt requirements-dev.txt
	docker buildx build --load --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --file $@ --platform $(PLATFORM) --tag $(REPO):$* --tag $(REPO):$(PANDAS_VERSION)-$* .

.PHONY: all clean push Dockerfile Dockerfile.%

requirements.txt: Pipfile.lock
	pipenv requirements > requirements.txt

requirements-dev.txt: Pipfile.lock
	pipenv requirements --dev > requirements-dev.txt

Pipfile.lock: Pipfile | .venv
	pipenv lock

.venv: Pipfile
	mkdir -p $@
	pipenv --python $(PYTHON_VERSION)
	touch $@
