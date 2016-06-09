FROM amancevice/pandas:0.18.1

RUN apk add --no-cache g++ && pip install notebook

EXPOSE 8888

WORKDIR /notebooks

CMD jupyter notebook --ip * --no-browser
