FROM python:2.7-alpine
RUN apk add --no-cache g++ freetype-dev libpng-dev && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install \
        cython==0.25.2 \
        jupyter==1.0.0 \
        matplotlib==1.5.1 \
        numpy==1.12.0 && \
    pip install pandas==<%= pandas %>
EXPOSE 8888
WORKDIR /notebooks
VOLUME /notebooks
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8888/"]
CMD jupyter notebook --ip 0.0.0.0 --no-browser
