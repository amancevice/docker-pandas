REPO           := amancevice/pandas
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

all: Pipfile.lock

clean:
	docker image ls --quiet $(REPO) | uniq | xargs docker image rm --force

alpine slim jupyter: lock
	docker build --tag $(REPO):$@ --tag $(REPO):$(PANDAS_VERSION)-$@ --target $@ .

latest:
	docker build --tag $(REPO):$@ --tag $(REPO):$(PANDAS_VERSION) --target $@ .

lock: Pipfile.lock

ls:
	docker image ls $(REPO)

push:
	 docker push --all-tags $(REPO)

.PHONY: all clean push alpine slim jupyter latest lock ls push

Pipfile.lock: Pipfile
	docker build --tag $(REPO):lock --target lock .
	docker run --rm --entrypoint cat $(REPO):lock $@ > $@
