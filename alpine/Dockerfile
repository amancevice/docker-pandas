FROM alpine:3.10
COPY requirements.txt /tmp/
RUN apk add --no-cache python3-dev libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install -r /tmp/requirements.txt && \
    apk del .build-deps
