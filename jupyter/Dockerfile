FROM python:3.7
COPY requirements.txt requirements-dev.txt /tmp/
RUN useradd -b /home -U -m jupyter && \
    pip install -r /tmp/requirements.txt -r /tmp/requirements-dev.txt
EXPOSE 8888
WORKDIR /notebooks
VOLUME /notebooks
USER jupyter
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8888/"]
CMD ["sh", "-c", "jupyter notebook --ip 0.0.0.0 --no-browser"]
