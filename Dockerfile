ARG ALPINE_VERSION=3.10
ARG PYTHON_VERSION=3.7

FROM python:alpine AS base
WORKDIR /var/lib/pandas/
COPY Pipfile* /var/lib/pandas/
RUN pip install pipenv==2018.11.26 && \
    pipenv lock -r > requirements.txt && \
    pipenv lock -r -d > requirements-dev.txt

FROM alpine:${ALPINE_VERSION} as alpine
WORKDIR /var/lib/pandas/
COPY --from=base /var/lib/pandas/ .
RUN apk add --no-cache python3-dev libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install -r requirements.txt && \
    apk del .build-deps

FROM python:${PYTHON_VERSION}-slim AS slim
WORKDIR /var/lib/pandas/
COPY --from=base /var/lib/pandas/ .
RUN pip install -r requirements.txt

FROM python:${PYTHON_VERSION} AS jupyter
WORKDIR /var/lib/pandas/
COPY --from=base /var/lib/pandas/ .
RUN pip install -r requirements.txt -r requirements-dev.txt

FROM python:${PYTHON_VERSION} AS latest
WORKDIR /var/lib/pandas/
COPY --from=base /var/lib/pandas/ .
RUN pip install -r requirements.txt
