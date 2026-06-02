echo "Deploying files to server..."
scp -r dist/* smc@172.18.7.91:/var/www/tiei_dynamic/

echo "Done...!"