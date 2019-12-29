for f in $(ls landmass_data)
do
    curl --header "Content-Type: application/json" --request POST -d @landmass_data/$f $1/land
done