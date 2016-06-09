# Pandas on Alpine Linux

Docker image based on alpine linux with pandas installed.

## Pull

The image tag name corresponds to the version of pandas installed.

```bash
# Get latest pandas
docker pull amancevice/pandas

# Get pandas 0.18.1
docker pull amancevice/pandas:0.18.1

# Get older pandas
docker pull amancevice/pandas:0.16.2
```


## Dockefile

Use the `FROM` keyword to build an image from a base with pandas pre-installed

```Dockerfile
FROM amancevice/pandas:0.18.1

RUN apk add --no-cache g++ && pip install notebook

EXPOSE 8888

WORKDIR /notebooks

CMD jupyter notebook --ip * --no-browser
```


## Example

Navigate to the [example](./example) directory of this project & bring up an example Jupyter notebook:

```bash
docker-compose up
```

After the image finishes building, navigate to [http://localhost:8888](http://localhost:8888).

Bring down the container with:

```bash
docker-compose down --rmi local
```
