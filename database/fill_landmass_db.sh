if [ $# -eq 0 ]; then
    echo "You must provide the path of Mapisto API"
    exit 1
fi
echo "Sending all landmass .json files in $(pwd)/landmass_data to Mapisto API on $1"
for f in $(ls landmass_data)
do
    curl --header "Content-Type: application/json" --request POST -d @landmass_data/$f $1/land
done