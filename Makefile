REPO           := amancevice/pandas
STAGES         := lock alpine slim jupyter latest
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

.PHONY: all clean clobber push

all: $(STAGES)

.docker:
	mkdir -p $@

.docker/lock:    Pipfile
.docker/latest:  .docker/jupyter Pipfile.lock
.docker/jupyter: .docker/latest
.docker/slim:    .docker/jupyter
.docker/alpine:  .docker/slim
.docker/%:     | .docker
	docker build --iidfile $@ --tag $(REPO):$* --target $* .

Pipfile.lock: .docker/lock
	docker run --rm --entrypoint cat $$(cat $<) $@ > $@

clean:
	rm -rf .docker

clobber: clean
	docker image ls $(REPO) --quiet | uniq | xargs docker image rm --force

push: all
	docker image push --all-tags $(REPO)

alpine slim jupyter:
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)-$*

latest:
	docker image tag $(REPO):$* $(REPO):$(PANDAS_VERSION)

lock: Pipfile.lock

$(STAGES): %: .docker/%
