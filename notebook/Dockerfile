FROM amancevice/pandas

RUN apk add --no-cache g++ git libpng-dev freetype-dev
RUN pip install notebook tornado pyzmq jinja2 matplotlib
RUN git clone https://github.com/jvns/pandas-cookbook.git

EXPOSE 8888

WORKDIR /pandas-cookbook

CMD ["sh", "-c", "jupyter notebook --ip=0.0.0.0 --no-browser"]
