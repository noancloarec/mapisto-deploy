# mapisto-deploy
## 1. Setup ssl certificates
The `doker-compose.yml` file supposes ssl certificates exist on the docker host : 
```yml
    volumes :
      - /etc/letsencrypt:/etc/letsencrypt
      - ./nginx_conf.d:/etc/nginx/conf.d
```
The nginx `default.conf` file uses 2 certificates : 
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
## 2. Get the deployment configuration
```bash
git clone git@github.com:cadoman/mapisto-deploy.git
cd mapisto-deploy

```
## 3.  Initialize the database
```bash
docker-compose up database

docker exec -it <the database container> sh
su - postgres

#Create your user
createuser --interactive --pwprompt
createdb -O <username> mapisto

# Create the tables
psql mapisto <username>
# Copy paste the content of database/create_db.sql , then exit the postgresql container

cp conf.example.env conf.env
nano conf.env 
#Edit it according to your postgre sql user & db

```

## 4. Fill the database with basic data
```bash
cd database
./fill_landmass_db.sh https://api.mapisto.org
```
# 5. Run mapisto
```bash
docker-compose up
```