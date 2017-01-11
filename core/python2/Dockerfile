FROM alpine:3.5
MAINTAINER smallweirdnum@gmail.com

RUN apk add --no-cache python2-dev py2-pip g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install numpy==1.11.3 cython==0.25.2
