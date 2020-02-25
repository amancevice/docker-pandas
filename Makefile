IMAGE          := amancevice/pandas
STAGES         := base alpine slim jupyter latest
CLEANS         := $(foreach STAGE,$(STAGES),clean@$(STAGE))
SHELLS         := $(foreach STAGE,$(STAGES),shell@$(STAGE))
PANDAS_VERSION := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')
TIMESTAMP      := $(shell date +%s)

.PHONY: all clean clobber push $(CLEANS) $(IMAGES) $(SHELLS) $(STAGES)

default: Pipfile.lock $(STAGES)

.docker:
	mkdir -p $@

.docker/base:    Pipfile
.docker/alpine:  .docker/base
.docker/slim:    .docker/alpine
.docker/jupyter: .docker/slim
.docker/latest:  .docker/jupyter
.docker/%:     | .docker
	docker build \
	--iidfile $@@$(TIMESTAMP) \
	--tag $(IMAGE):$* \
	--target $* \
	.
	cp $@@$(TIMESTAMP) $@

Pipfile.lock: .docker/base
	docker run --rm --entrypoint cat $(shell cat $<) $@ > $@

clean: $(CLEANS)
	-for i in $$(docker image ls --filter dangling=true --quiet --no-trunc); do for j in $$(grep -l $$i .docker/*); do docker image rm --force $$i; rm $$j; done; done

clobber: clean
	-docker image ls --no-trunc --quiet $(IMAGE) | uniq | xargs docker image rm --force
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

alpine slim jupyter: %: .docker/%
	docker tag $(IMAGE):$* $(IMAGE):$(PANDAS_VERSION)-$*

latest: %: .docker/%
	docker tag $(IMAGE):$* $(IMAGE):$(PANDAS_VERSION)

$(CLEANS): clean@%:
	-rm -rf .docker/$*

$(SHELLS): shell@%: .docker/%
	docker run --rm -it --entrypoint sh $(shell cat $<)
