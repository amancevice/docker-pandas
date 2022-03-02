ARG PYTHON_VERSION=3.10

FROM python:$PYTHON_VERSION AS lock
WORKDIR /var/lib/pandas/
RUN pip install pipenv==2022.3.28
RUN pipenv --python $PYTHON_VERSION
COPY Pipfile* /var/lib/pandas/
RUN pipenv lock --requirements > requirements.txt
RUN pipenv lock --requirements --dev > requirements-dev.txt
CMD [ "tar", "-c", "Pipfile.lock", "requirements.txt", "requirements-dev.txt" ]

FROM python:$PYTHON_VERSION AS latest
WORKDIR /var/lib/pandas
COPY requirements.txt ./
RUN pip install $(grep -Eho 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt

FROM python:$PYTHON_VERSION AS jupyter
WORKDIR /var/lib/pandas
COPY requirements*.txt ./
RUN pip install $(grep -Eho 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt -r requirements-dev.txt

FROM python:$PYTHON_VERSION-slim AS slim
WORKDIR /var/lib/pandas
COPY requirements.txt ./
RUN pip install $(grep -Eho 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt

FROM python:$PYTHON_VERSION-alpine as alpine
WORKDIR /var/lib/pandas
COPY requirements.txt ./
RUN apk add --no-cache libstdc++  && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install $(grep -Eho 'numpy==[0-9.]+' requirements.txt) && \
    pip install -r requirements.txt && \
    apk del .build-deps
