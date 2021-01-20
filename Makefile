REPO           := amancevice/pandas
STAGES         := lock latest jupyter slim alpine
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

all: Pipfile.lock

build: $(STAGES)

clean:
	rm -rf .docker

clobber: clean
	docker image ls --quiet $(REPO) | uniq | xargs docker image rm --force

push: build
	docker image push $(REPO):alpine
	docker image push $(REPO):slim
	docker image push $(REPO):jupyter
	docker image push $(REPO):latest
	docker image push $(REPO):$(PANDAS_VERSION)-alpine
	docker image push $(REPO):$(PANDAS_VERSION)-slim
	docker image push $(REPO):$(PANDAS_VERSION)-jupyter
	docker image push $(REPO):$(PANDAS_VERSION)

alpine slim jupyter:
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)-$*

latest:
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)

lock: Pipfile.lock

$(STAGES): %: .docker/%

.PHONY: all build clean clobber push $(STAGES)

Pipfile.lock: Pipfile | .docker/lock
	docker run --rm --entrypoint cat $(REPO):lock $@ > $@

.docker/lock: Pipfile
.docker/latest: .docker/lock Pipfile.lock
.docker/jupyter: .docker/latest
.docker/slim: .docker/jupyter
.docker/alpine: .docker/slim
.docker/%: | .docker
	docker build --iidfile $@ --tag $(REPO):$* --target $* .

.docker:
	mkdir -p $@
