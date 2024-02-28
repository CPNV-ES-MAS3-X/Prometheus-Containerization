# Stop all containers
sudo docker stop `docker ps -qa`

# Remove all containers
sudo docker rm `docker ps -qa`

# Remove all images
sudo docker rmi -f `docker images -qa `

# Remove all volumes
sudo docker volume rm $(docker volume ls -q)
sudo docker volume rm $(docker volume ls -qf dangling="true")

# Remove all networks
sudo docker network rm `docker network ls -q`

# Your installation should now be all fresh and clean.

# The following commands should not output any items:
# docker ps -a
# docker images -a
# docker volume ls

# The following command show only show the default networks:
# docker network ls


sudo docker stop `docker ps -qa`
sudo docker rm `docker ps -qa`
sudo docker rmi -f `docker images -qa `
sudo docker volume rm $(docker volume ls -q)
sudo docker volume rm $(docker volume ls -qf dangling="true")
sudo docker network rm `docker network ls -q`




#tag and push 
docker build --no-cache -t grafana .
docker tag grafana:latest datchos/grafana:v1
docker push datchos/grafana:v1