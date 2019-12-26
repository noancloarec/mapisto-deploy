# mapisto-deploy
```bash
git clone git@github.com:cadoman/mapisto-deploy.git
cd mapisto-deploy

cp db_access.example.env db_access.env
nano db_access.env #Edit it according to your needs
docker-compose up

# Initialize the database
docker exec -it <the database container> sh
su - postgres

#Create your user
createuser --interactive --pwprompt
createdb -O <username> mapisto

# Create the tables
psql mapisto <username>
# Paste the content of create_db.sql and fill_landmass_db.sql
```
