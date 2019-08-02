pandas_version := 0.25.0
stages         := lock alpine slim jupyter latest
flavors        := alpine slim jupyter
shells         := $(foreach stage,$(stages),shell@$(stage))

.PHONY: all clean $(stages) $(shells)

all: Pipfile Pipfile.lock $(stages)

.docker:
	mkdir -p $@

.docker/$(pandas_version)@alpine: .docker/$(pandas_version)@lock
.docker/$(pandas_version)@slim: .docker/$(pandas_version)@alpine
.docker/$(pandas_version)@jupyter: .docker/$(pandas_version)@slim
.docker/$(pandas_version)@latest: .docker/$(pandas_version)@jupyter
.docker/$(pandas_version)@%: | .docker
	docker build \
	--build-arg PANDAS_VERSION=$(pandas_version) \
	--iidfile $@ \
	--tag amancevice/pandas:$* \
	--target $* .

Pipfile Pipfile.lock: .docker/$(pandas_version)@lock
	docker run --rm $(shell cat $<) cat $@ > $@

clean:
	-docker image rm $(shell awk {print} .docker/*)
	-rm -rf .docker

$(stages): %: .docker/$(pandas_version)@%

alpine slim jupyter: %: .docker/$(pandas_version)@%
	docker tag amancevice/pandas:$* amancevice/pandas:$(pandas_version)-$*

latest: %: .docker/$(pandas_version)@%
	docker tag amancevice/pandas:$* amancevice/pandas:$(pandas_version)

$(shells): shell@%: .docker/$(pandas_version)@%
