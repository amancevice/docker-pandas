image  := amancevice/pandas
stages := base alpine slim jupyter latest
shells := $(foreach stage,$(stages),shell@$(stage))

alpine_version := 3.10
python_version := $(shell grep python_version Pipfile | grep -o '[0-9.]\+')
pandas_version := $(shell grep pandas Pipfile | grep -o '[0-9.]\+')

.PHONY: all clean push $(stages) $(shells)

all: Pipfile Pipfile.lock $(stages)

.docker:
	mkdir -p $@

.docker/$(pandas_version)@alpine: .docker/$(pandas_version)@base
.docker/$(pandas_version)@slim: .docker/$(pandas_version)@alpine
.docker/$(pandas_version)@jupyter: .docker/$(pandas_version)@slim
.docker/$(pandas_version)@latest: .docker/$(pandas_version)@jupyter
.docker/$(pandas_version)@%: | .docker
	docker build \
	--build-arg ALPINE_VERSION=$(alpine_version) \
	--build-arg PYTHON_VERSION=$(python_version) \
	--iidfile $@ \
	--tag $(image):$* \
	--target $* .

Pipfile Pipfile.lock: .docker/$(pandas_version)@base
	docker run --rm $(shell cat $<) cat $@ > $@

clean:
	-docker image rm $(shell awk {print} .docker/*)
	-rm -rf .docker

push: all
	docker push \
	$(image):alpine \
	$(image):slim \
	$(image):jupyter \
	$(image):latest \
	$(image):$(pandas_version)-alpine \
	$(image):$(pandas_version)-slim \
	$(image):$(pandas_version)-jupyter \
	$(image):$(pandas_version)

$(stages): %: .docker/$(pandas_version)@%

alpine slim jupyter: %: .docker/$(pandas_version)@%
	docker tag $(image):$* $(image):$(pandas_version)-$*

latest: %: .docker/$(pandas_version)@%
	docker tag $(image):$* $(image):$(pandas_version)

$(shells): shell@%: .docker/$(pandas_version)@%
