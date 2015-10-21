
echo "Setup repos..."
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "# Ubuntu Vivid\ndeb https://apt.dockerproject.org/repo ubuntu-vivid main" > /etc/apt/sources.list.d/docker.list
sudo apt-get update
apt-cache policy docker-engine

echo "Install packages..."
sudo apt-get install -y \
    vim \
    python-setuptools \
    docker-engine \
    python-pip
sudo easy_install pip
sudo pip install docker-py

echo "Cleanup..."
sudo apt-get purge lxc-docker*

echo "Configure settings and groups..."
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker start
echo "set number hlsearch tabstop=8 softtabstop=4 expandtab shiftwidth=4 wrap" >> ~/.vimrc
