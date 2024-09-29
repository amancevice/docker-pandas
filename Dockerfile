ARG PYTHON_VERSION=3.12
FROM python:$PYTHON_VERSION
WORKDIR /var/lib/pandas/
COPY . .
RUN pip install -r requirements.txt
