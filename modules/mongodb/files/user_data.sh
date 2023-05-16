#!/bin/bash -ex
  
# Update the packace indexes and install mongodb
apt-get update && \
sudo apt-get -y install mongodb-clients mongodb-server && \
sed -i -e '/^bind_ip/s/^.*$/bind_ip=0.0.0.0/' /etc/mongodb.conf && \
sudo service mongodb restart && \
sleep 10 && \
wget --quiet https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json

for i in {1..5}; do mongoimport --db example_data --collection restaurants --drop --file primer-dataset.json && break || sleep 10; done

exit 0