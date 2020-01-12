# mapisto-deploy
## 1. Setup ssl certificates
The `doker-compose.yml` file supposes ssl certificates exists on the docker host : 
```yml
    volumes :
      - /etc/letsencrypt:/etc/letsencrypt
      - ./nginx_conf.d:/etc/nginx/conf.d
```
The nginx `default.conf` file then uses 2 certificates : 
```
    ssl_certificate /etc/letsencrypt/live/mapisto.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mapisto.org/privkey.pem;
    ...
    ssl_certificate /etc/letsencrypt/live/api.mapisto.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.mapisto.org/privkey.pem;
```
So we need to ensure that thse certificates are present and valid on the host machine :
```
/etc/letsencrypt/live/mapisto.org/fullchain.pem;
/etc/letsencrypt/live/mapisto.org/privkey.pem;
/etc/letsencrypt/live/api.mapisto.org/fullchain.pem;
/etc/letsencrypt/live/api.mapisto.org/privkey.pem;
```
## 2. Deploy containers
```bash
git clone git@github.com:cadoman/mapisto-deploy.git
cd mapisto-deploy

cp conf.example.env conf.env
nano conf.env 
#Edit it according to your needs
docker-compose up

# Initialize the database
docker exec -it <the database container> sh
su - postgres

#Create your user
createuser --interactive --pwprompt
createdb -O <username> mapisto

# Create the tables
psql mapisto <username>
```
