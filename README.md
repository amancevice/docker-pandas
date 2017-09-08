# Pandas

Docker image with [pandas](https://github.com/pandas-dev/pandas) installed.

## Pulling

Pull image tags with the `pandas` and Python versions you wish to use:

```bash
docker pull amancevice/pandas:x.y.z-python2
docker pull amancevice/pandas:x.y.z-python3
```

For slim images append `-slim` to the tag:

```bash
docker pull amancevice/pandas:x.y.z-python2-slim
docker pull amancevice/pandas:x.y.z-python3-slim
```

For alpine-based images append `-alpine` to the tag:

```bash
docker pull amancevice/pandas:x.y.z-python2-alpine
docker pull amancevice/pandas:x.y.z-python3-alpine
```

## Building

Use the `build.py` script to build a specific version:

```bash
./build.py [latest|slim|alpine|jupyter] -v 0.20.3 -v ...
```
