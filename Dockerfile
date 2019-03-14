FROM python:3.7
ARG PANDAS_VERSION=0.24.2
RUN pip install pandas==${PANDAS_VERSION}
