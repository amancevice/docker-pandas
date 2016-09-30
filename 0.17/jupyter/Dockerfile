FROM amancevice/pandas:0.17.1-python2
MAINTAINER smallweirdnum@gmail.com
RUN apk add --no-cache freetype-dev gcc g++ libpng-dev && \
    pip install jupyter==1.0.0 matplotlib==1.5.1
EXPOSE 8888
CMD jupyter notebook --ip 0.0.0.0 --no-browser
