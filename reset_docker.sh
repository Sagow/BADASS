docker stop $(docker ps -aq)
docker system prune
docker rmi $(docker images -q)