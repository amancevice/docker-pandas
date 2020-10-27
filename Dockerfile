ARG ALPINE_VERSION=3.12
ARG PYTHON_VERSION=3.8

FROM python:${PYTHON_VERSION} AS lock
WORKDIR /var/lib/pandas/
RUN pip install pipenv==2020.8.13
RUN pipenv install 2>&1
COPY Pipfile* /var/lib/pandas/
RUN pipenv lock --requirements > requirements.txt
RUN pipenv lock --requirements --dev > requirements-dev.txt

FROM python:${PYTHON_VERSION} AS latest
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep -Eoh 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt

FROM python:${PYTHON_VERSION} AS jupyter
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep -Eoh 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt -r requirements-dev.txt

FROM python:${PYTHON_VERSION}-slim AS slim
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep -Eoh 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt

FROM python:${PYTHON_VERSION}-alpine as alpine
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN apk add --no-cache libstdc++  && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install $(grep -Eoh 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt && \
    apk del .build-deps
