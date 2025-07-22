ARG PYTHON_VERSION=3.13
FROM python:$PYTHON_VERSION
WORKDIR /var/lib/pandas/
COPY . .
RUN pip install -r requirements.txt
