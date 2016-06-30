FROM alpine
MAINTAINER smallweirdnum@gmail.com

ENV PANDAS_VERSION 0.17.1
RUN apk add --no-cache python-dev py-pip && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install numpy==1.11.0 && \
    pip install pandas==$PANDAS_VERSION && \
    apk del .build-deps
