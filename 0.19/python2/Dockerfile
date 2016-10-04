FROM alpine:3.4
MAINTAINER smallweirdnum@gmail.com

ENV PANDAS_VERSION 0.19.0
RUN apk add --no-cache python-dev py-pip g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install numpy==1.11.1 cython==0.24.1 && \
    pip install pandas==$PANDAS_VERSION
