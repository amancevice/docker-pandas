#/bin/sh

# pandas versions
pandas_0_16=0.16.2
pandas_0_17=0.17.1
pandas_0_18=0.18.1
pandas_0_19=0.19.0

# 0.16
dir=0.16
erb pandas=$pandas_0_16 Dockerfile-jupyter.erb > $dir/jupyter/Dockerfile
erb pandas=$pandas_0_16 Dockerfile-python2.erb > $dir/python2/Dockerfile
erb pandas=$pandas_0_16 Dockerfile-python3.erb > $dir/python3/Dockerfile

# 0.17
dir=0.17
erb pandas=$pandas_0_17 Dockerfile-jupyter.erb > $dir/jupyter/Dockerfile
erb pandas=$pandas_0_17 Dockerfile-python2.erb > $dir/python2/Dockerfile
erb pandas=$pandas_0_17 Dockerfile-python3.erb > $dir/python3/Dockerfile

# 0.18
dir=0.18
erb pandas=$pandas_0_18 Dockerfile-jupyter.erb > $dir/jupyter/Dockerfile
erb pandas=$pandas_0_18 Dockerfile-python2.erb > $dir/python2/Dockerfile
erb pandas=$pandas_0_18 Dockerfile-python3.erb > $dir/python3/Dockerfile

# 0.19
dir=0.19
erb pandas=$pandas_0_19 Dockerfile-jupyter.erb > $dir/jupyter/Dockerfile
erb pandas=$pandas_0_19 Dockerfile-python2.erb > $dir/python2/Dockerfile
erb pandas=$pandas_0_19 Dockerfile-python3.erb > $dir/python3/Dockerfile
