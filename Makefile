IMAGE  := amancevice/pandas
STAGES    := base alpine slim jupyter latest
IMAGES    := $(foreach STAGE,$(STAGES),image@$(STAGE))
SHELLS    := $(foreach STAGE,$(STAGES),shell@$(STAGE))
TIMESTAMP := $(shell date +%s)

ALPINE_VERSION := 3.10
PYTHON_VERSION := $(shell grep python_version Pipfile | grep -o '[0-9.]\+')
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

.PHONY: all clean clobber push $(IMAGES) $(SHELLS)

default: Pipfile.lock $(IMAGES)

.docker:
	mkdir -p $@

.docker/$(PANDAS_VERSION)-alpine:  .docker/$(PANDAS_VERSION)-base
.docker/$(PANDAS_VERSION)-slim:    .docker/$(PANDAS_VERSION)-alpine
.docker/$(PANDAS_VERSION)-jupyter: .docker/$(PANDAS_VERSION)-slim
.docker/$(PANDAS_VERSION)-latest:  .docker/$(PANDAS_VERSION)-jupyter
.docker/$(PANDAS_VERSION)-%:     | .docker
	docker build \
	--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
	--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
	--iidfile $@@$(TIMESTAMP) \
	--tag $(IMAGE):$* \
	--target $* \
	.
	cp $@@$(TIMESTAMP) $@

Pipfile.lock: .docker/$(PANDAS_VERSION)-base
	docker run --rm $(shell cat $<) cat $@ > $@

clean:
	-find .docker -name '$(PANDAS_VERSION)-*' -not -name '*@*' | xargs rm

clobber:
	-awk {print} .docker/* 2> /dev/null | uniq | xargs docker image rm --force
	-rm -rf .docker

push: default
	docker push $(IMAGE):alpine
	docker push $(IMAGE):slim
	docker push $(IMAGE):jupyter
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(PANDAS_VERSION)-alpine
	docker push $(IMAGE):$(PANDAS_VERSION)-slim
	docker push $(IMAGE):$(PANDAS_VERSION)-jupyter
	docker push $(IMAGE):$(PANDAS_VERSION)

alpine slim jupyter: %: .docker/$(PANDAS_VERSION)-%
	docker tag $(IMAGE):$* $(IMAGE):$(PANDAS_VERSION)-$*

latest: %: .docker/$(PANDAS_VERSION)-%
	docker tag $(IMAGE):$* $(IMAGE):$(PANDAS_VERSION)

$(IMAGES): image@%: .docker/$(PANDAS_VERSION)-%

$(SHELLS): shell@%: .docker/$(PANDAS_VERSION)-%
	docker run --rm -it --entrypoint /bin/sh $(shell cat $<)
