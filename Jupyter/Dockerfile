FROM python:2.7
ARG PANDAS_VERSION
ENV PANDAS_VERSION ${PANDAS_VERSION:-0.20.2}
RUN useradd -b /home -U -m jupyter && \
    pip install \
        jupyter==1.0.0 \
        matplotlib==1.5.1 \
        pandas==$PANDAS_VERSION
EXPOSE 8888
WORKDIR /home/jupyter/notebooks
VOLUME /home/jupyter/notebooks
USER jupyter
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8888/"]
CMD jupyter notebook --ip 0.0.0.0 --no-browser
