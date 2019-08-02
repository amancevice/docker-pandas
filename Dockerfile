FROM python:3.7 AS lock
WORKDIR /var/lib/pandas/
COPY Pipfile* /var/lib/pandas/
ARG PANDAS_VERSION=0.25.0
RUN pip install pipenv==2018.11.26 && \
    pipenv install pandas==${PANDAS_VERSION} && \
    pipenv lock -r > requirements.txt && \
    pipenv lock -r -d > requirements-dev.txt

FROM alpine:3.10 as alpine
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN apk add --no-cache python3-dev libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install -r requirements.txt && \
    apk del .build-deps

FROM python:3.7-slim AS slim
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install -r requirements.txt

FROM python:3.7 AS jupyter
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install -r requirements.txt -r requirements-dev.txt

FROM python:3.7 AS latest
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install -r requirements.txt
