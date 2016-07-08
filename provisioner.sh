#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.0.list
echo "deb http://repo.pritunl.com/stable/apt trusty main" > /etc/apt/sources.list.d/pritunl.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7F0CEB10
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv CF8E292A
apt-get -y update
apt-get -y install pritunl mongodb-org
service pritunl start


SETUP_KEY=`pritunl setup-key`



while ! curl -k -H 'Content-Type: application/json' -X PUT -d "{\"setup_key\":\"${SETUP_KEY}\", \"mongodb_uri\":\"mongodb://localhost:27017/pritunl\"}" "https://localhost/setup/mongodb"
do
    echo "Automatically setting setup key and mongo url"
    ((c++)) && ((c==10)) && break
    sleep 1
done
