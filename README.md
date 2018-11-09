# Pandas

Docker image with [pandas](https://github.com/pandas-dev/pandas) installed.

_Note: images using Python 2.7 are no longer supported_

## Pulling

Pull image tags with the `pandas` version you wish to use:

```bash
docker pull amancevice/pandas:x.y.z
```

For slim images append `-slim` to the tag:

```bash
docker pull amancevice/pandas:x.y.z-slim
```

For alpine-based images append `-alpine` to the tag:

```bash
docker pull amancevice/pandas:x.y.z-alpine
```

## Building

Use the `build.py` script to build a specific version:

```bash
./build.py -v0.23.0
```
