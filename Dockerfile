FROM alpine
MAINTAINER smallweirdnum@gmail.com

RUN apk add --no-cache python-dev py-pip && \
    apk add --no-cache --virtual pandas-dependencies g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install numpy==1.11.0 && \
    pip install pandas==0.16.2 && \
    apk del pandas-dependencies
