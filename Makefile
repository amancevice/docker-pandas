REPO           := amancevice/pandas
STAGES         := lock alpine slim jupyter latest
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

.PHONY: default clean clobber push

default: $(STAGES)

.docker:
	mkdir -p $@

.docker/lock:    Pipfile
.docker/alpine:  .docker/lock Pipfile.lock
.docker/slim:    .docker/alpine
.docker/jupyter: .docker/slim
.docker/latest:  .docker/jupyter
.docker/%:     | .docker
	docker build --iidfile $@ --tag $(REPO):$* --target $* .

Pipfile.lock: .docker/lock
	docker run --rm --entrypoint cat $$(cat $<) $@ > $@

clean:
	rm -rf .docker

clobber: clean
	docker image ls $(REPO) --quiet | uniq | xargs docker image rm --force

push: default
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
