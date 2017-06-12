# Pandas

Docker image with [pandas](https://github.com/pandas-dev/pandas) installed.

## Pulling

Pull image tags with the `pandas` and Python versions you wish to use:

```bash
docker pull amancevice/pandas:0.0.0-python2
docker pull amancevice/pandas:0.0.0-python3
```

For alpine-based images append `-alpine` to the tag:

```bash
docker pull amancevice/pandas:0.0.0-python2-alpine
docker pull amancevice/pandas:0.0.0-python3-alpine
```

## Building

Use `docker-compose` to build a specific version:

```bash
docker-compose build pandas-0.0.0-python2
docker-compose build pandas-0.0.0-python3
docker-compose build pandas-0.0.0-python2-alpine
docker-compose build pandas-0.0.0-python3-alpine
```
