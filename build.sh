#!/bin/sh

for pd in 0.16 0.17 0.18 0.19; do
  for py in python2 python3; do
    docker build -t amancevice/pandas:$pd-$py $pd/$py
  done
  docker build -t amancevice/pandas:$pd-jupyter $pd/jupyter
done

docker tag amancevice/pandas:0.16-python2 amancevice/pandas:0.16.2-python2
docker tag amancevice/pandas:0.16-python2 amancevice/pandas:0.16.2
docker tag amancevice/pandas:0.16-python2 amancevice/pandas:0.16

docker tag amancevice/pandas:0.17-python2 amancevice/pandas:0.17.1-python2
docker tag amancevice/pandas:0.17-python2 amancevice/pandas:0.17.1
docker tag amancevice/pandas:0.17-python2 amancevice/pandas:0.17

docker tag amancevice/pandas:0.18-python2 amancevice/pandas:0.18.1-python2
docker tag amancevice/pandas:0.18-python2 amancevice/pandas:0.18.1
docker tag amancevice/pandas:0.18-python2 amancevice/pandas:0.18

docker tag amancevice/pandas:0.19-python2 amancevice/pandas:0.19.0-python2
docker tag amancevice/pandas:0.19-python2 amancevice/pandas:0.19.0
docker tag amancevice/pandas:0.19-python2 amancevice/pandas:0.19
docker tag amancevice/pandas:0.19-python2 amancevice/pandas

docker tag amancevice/pandas:0.16-jupyter amancevice/pandas:0.16.2-jupyter
docker tag amancevice/pandas:0.17-jupyter amancevice/pandas:0.17.1-jupyter
docker tag amancevice/pandas:0.18-jupyter amancevice/pandas:0.18.1-jupyter
docker tag amancevice/pandas:0.19-jupyter amancevice/pandas:0.19.0-jupyter
docker tag amancevice/pandas:0.19-jupyter amancevice/pandas:jupyter

docker tag amancevice/pandas:0.16-python3 amancevice/pandas:0.16.2-python3
docker tag amancevice/pandas:0.17-python3 amancevice/pandas:0.17.1-python3
docker tag amancevice/pandas:0.18-python3 amancevice/pandas:0.18.1-python3
docker tag amancevice/pandas:0.19-python3 amancevice/pandas:0.19.0-python3

docker push amancevice/pandas
