#!/bin/bash
set -x
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.0.list
echo "deb http://repo.pritunl.com/stable/apt trusty main" > /etc/apt/sources.list.d/pritunl.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7F0CEB10
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv CF8E292A
apt-get -y update
apt-get -y install pritunl mongodb-org
service pritunl start


SETUP_KEY=`pritunl setup-key`

while ! openssl s_client -showcerts -connect localhost:443 > /tmp/cacert.pem
do
    ((c++)) && ((c==30)) && break
    sleep 1
done

curl --cacert /tmp/cacert.pem -H 'Content-Type: application/json' -X PUT -d "{\"setup_key\":\"${SETUP_KEY}\", \"mongodb_uri\":\"mongodb://localhost:27017/pritunl\"}" "https://localhost/setup/mongodb"
