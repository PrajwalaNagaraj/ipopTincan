#!/bin/bash

#download and install dependencies
python_version="python3"
psutil_version=5.6.3
sleekxmpp_version=1.3.3
requests_version=2.21.0
simplejson_version=3.16.0
ryu_version=4.30
sudo apt update -y
sudo apt install -y git make libssl-dev g++-5 $python_version $python_version-pip $python_version-dev openvswitch-switch iproute2 bridge-utils
sudo -H $python_version -m pip install --upgrade pip
sudo -H $python_version -m pip --no-cache-dir install psutil==$psutil_version sleekxmpp==$sleekxmpp_version requests==$requests_version simplejson==$simplejson_version ryu==$ryu_version

mkdir -p ~/workspace
cd ~/workspace
git clone https://github.com/EdgeVPNio/evio.git
git clone -b ubuntu-x64 --single-branch https://github.com/EdgeVPNio/external.git tincan/external/
