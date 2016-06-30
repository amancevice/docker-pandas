FROM alpine
MAINTAINER smallweirdnum@gmail.com

ENV PANDAS_VERSION 0.16.2
RUN apk add --no-cache python3-dev && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install numpy==1.11.0 && \
    pip3 install pandas==$PANDAS_VERSION && \
    apk del .build-deps