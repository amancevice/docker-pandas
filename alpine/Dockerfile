FROM alpine:3.8
ARG PANDAS_VERSION=0.24.1
RUN apk add --no-cache python3-dev libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install numpy==1.15.1 && \
    pip3 install pandas==${PANDAS_VERSION} && \
    apk del .build-deps
