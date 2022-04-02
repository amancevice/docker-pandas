REPO           := amancevice/pandas
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

all: Pipfile.lock

clean:
	docker image ls --quiet $(REPO) | uniq | xargs docker image rm --force

push:
	docker image push $(REPO):alpine
	docker image push $(REPO):slim
	docker image push $(REPO):jupyter
	docker image push $(REPO):latest
	docker image push $(REPO):$(PANDAS_VERSION)-alpine
	docker image push $(REPO):$(PANDAS_VERSION)-slim
	docker image push $(REPO):$(PANDAS_VERSION)-jupyter
	docker image push $(REPO):$(PANDAS_VERSION)

alpine slim jupyter: lock
	docker build --tag $(REPO):$@ --tag $(REPO):$(PANDAS_VERSION)-$@ --target $@ .

latest: lock
	docker build --tag $(REPO):$@ --tag $(REPO):$(PANDAS_VERSION)-$@ --target $@ .
	docker image tag $(REPO):$@ $(REPO):$(PANDAS_VERSION)

lock: Pipfile.lock

.PHONY: all clean push alpine slim jupyter latest lock

Pipfile.lock: Pipfile
	docker build --tag $(REPO):lock --target lock .
	docker run --rm --entrypoint cat $(REPO):lock $@ > $@
