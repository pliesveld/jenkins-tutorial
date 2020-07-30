docker-compose stop
docker-compose rm
docker-compose up -d --force-recreate
docker-compose logs -f 
