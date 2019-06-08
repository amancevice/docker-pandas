image  := amancevice/pandas
version = $(shell grep 'pandas' Pipfile | cut -f2 -d'"' | cut -f3 -d=)

.PHONY: all alpine clean jupyter latest slim

all: \
	Pipfile.lock \
	requirements-dev.txt \
	requirements.txt \
	.docker/$(version) \
	.docker/$(version)-alpine \
	.docker/$(version)-jupyter \
	.docker/$(version)-slim \
	.docker/alpine \
	.docker/jupyter \
	.docker/latest \
	.docker/slim

clean:
	-docker image rm -f $(shell sed G .docker/*)
	-rm -rf .docker

.docker: requirements.txt
	mkdir -p $@

.docker/latest: | .docker
	docker build --iidfile $@ --tag amancevice/pandas .

.docker/$(version): | .docker
	docker build --iidfile $@ --tag amancevice/pandas:$(version) .

.docker/%: | .docker
	docker build --iidfile $@ --tag amancevice/pandas:$* $(lastword $(subst -, ,$*))

Pipfile.lock: Pipfile
	pipenv lock

requirements.txt: Pipfile.lock
	pipenv lock -r > $@
	cp $@ alpine/$@
	cp $@ jupyter/$@
	cp $@ slim/$@

requirements-dev.txt: Pipfile.lock
	pipenv lock -r -d > $@
	cp $@ jupyter/$@
