echo INSIDE DOCKER BOOT.
git clone https://github.com/dataf3l/DockerHackathonSf2015.git
cd DockerHackathonSf2015

#fetch lastest
git pull origin master
cd docker-images/firstImage

#attempt to build image
docker build .
