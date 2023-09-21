REPO           := amancevice/pandas
PLATFORM       := linux/amd64
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -Eo '[0-9.]+')
PIPENV_VERSION := $(shell pipenv --version | grep -Eo '[0-9.]+')
PYTHON_VERSION := $(shell python --version | grep -Eo '[0-9.]+')

all: Pipfile.lock

clean:
	docker image rm --force $(shell docker image ls --quiet $(REPO) | uniq | xargs)

push:
	docker push --all-tags $(REPO)

Dockerfile: requirements.txt
	docker buildx build --load --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --platform $(PLATFORM) --tag $(REPO) --tag $(REPO):$(PANDAS_VERSION) .

Dockerfile.%: requirements.txt requirements-dev.txt
	docker buildx build --load --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --file $@ --platform $(PLATFORM) --tag $(REPO):$* --tag $(REPO):$(PANDAS_VERSION)-$* .

.PHONY: all clean push Dockerfile Dockerfile.%

requirements.txt:
	pipenv requirements > requirements.txt

requirements-dev.txt:
	pipenv requirements --dev > requirements-dev.txt

Pipfile.lock: .venv
	docker container run --detach --rm --name pandas python:3.11.5 python -m http.server
	docker container exec --tty pandas pip install pipenv==$(PIPENV_VERSION) &> /dev/null
	docker container cp Pipfile* pandas:/tmp/
	docker container exec --tty --workdir /tmp/ pandas pipenv lock
	docker container cp pandas:/tmp/Pipfile.lock .
	docker container stop pandas

.venv: Pipfile
	mkdir -p $@
	pipenv --python $(PYTHON_VERSION)
	touch $@
