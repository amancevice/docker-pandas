image := amancevice/pandas
tag   := 0.24.2

.PHONY: lock alpine jupyter slim latest all

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

lock: requirements.txt requirements-dev.txt

alpine:
	docker build -t $(image):$@ $@
	docker tag $(image):$@ $(image):$(tag)-$@

jupyter:
	docker build -t $(image):$@ $@
	docker tag $(image):$@ $(image):$(tag)-$@

slim:
	docker build -t $(image):$@ $@
	docker tag $(image):$@ $(image):$(tag)-$@

latest:
	docker build -t $(image):$@ .
	docker tag $(image):$@ $(image):$(tag)

all: latest slim jupyter alpine
