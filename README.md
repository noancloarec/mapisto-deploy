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
cp conf.example.env conf.env
cp conf.dev.example.env conf.dev.env

docker-compose up -d database-prod database-dev
```
For both dev and prod environment, create and fill the 2 separate database
1. prod
```bash
docker exec -it mapisto-deploy_database-prod_1 sh

su - postgres

#Create your user
createuser --interactive --pwprompt
createdb -O <username> mapisto

# Create the tables
psql mapisto <username>
# Copy paste the content of database/create_db.sql , then exit the postgresql container
exit

nano conf.env 
# fill your user name and your user password
```
2. dev
```bash
docker exec -it mapisto-deploy_database-dev_1 sh

su - postgres

#Create your user (answer no to all y/n question)
createuser --interactive --pwprompt
createdb -O <username> mapisto

# Create the tables
psql mapisto <username>
# Copy paste the content of database/create_db.sql 

# Now exit the postgresql container


# fill your user name and your user password
nano conf.dev.env 
```
## 4. Create elasticsearch directory for logs
```bash
mkdir -p $HOME/docker/volumes/elasticsearch_data
chmod -R 777 $HOME/docker/volumes/elasticsearch_data
```
## 5. Fill the database with basic data
```bash
cd database
./fill_landmass_db.sh https://api.mapisto.org
./fill_landmass_db.sh https://api.dev.mapisto.org
```
## 6. Run mapisto
```bash
docker-compose up
```

# Debug
In order to run all mapisto on localhost, here is a procedure
```bash
# Override /etc/hosts to emulate mapisto locally
# mapisto.org will be unavailable until you remove these lines from the file
echo "
# Temporary resolver to debug mapisto 
127.0.0.1 mapisto.org 
127.0.0.1 api.mapisto.org 
127.0.0.1 dev.mapisto.org 
127.0.0.1 api.dev.mapisto.org 
127.0.0.1 monitor.mapisto.org 
" | sudo tee -a /etc/hosts
```
Execute the steps 2, 3, 4.
Fill landmass, same as in step 5 but with http instead
```bash
docker-compose -f docker-compose.http_only.yml up -d
cd database
./fill_landmass_db.sh http://api.mapisto.org
./fill_landmass_db.sh http://api.dev.mapisto.org
```
