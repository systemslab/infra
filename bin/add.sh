sudo apt-get install -y vim git

echo "set number hlsearch tabstop=8 softtabstop=4 expandtab shiftwidth=4 wrap" >> ~/.vimrc

apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "# Ubuntu Vivid\ndeb https://apt.dockerproject.org/repo ubuntu-vivid main" > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get purge lxc-docker*
apt-cache policy docker-engine
sudo apt-get install -y docker-engine
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker start

sudo apt-get install python-pip
sudo pip install docker-py
