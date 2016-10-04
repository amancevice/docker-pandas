FROM alpine:3.4
MAINTAINER smallweirdnum@gmail.com

RUN apk add --no-cache python3-dev g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install numpy==1.11.1 cython==0.24.1
RUN pip3 install pandas==0.17.1
