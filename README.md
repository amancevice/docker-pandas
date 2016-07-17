# Pandas on Alpine Linux

Docker image based on alpine linux with pandas installed.


## Python2

```bash
# Get pandas 0.18.1
docker pull amancevice/pandas:0.18.1

# Get older pandas
docker pull amancevice/pandas:0.16.2
```


## Python3

```bash
# Get pandas 0.18.1
docker pull amancevice/pandas:0.18.1-python3

# Get older pandas
docker pull amancevice/pandas:0.16.2-python3
```


## Dockerfile

```Dockerfile
FROM amancevice/pandas:0.18.1
# ...
```
