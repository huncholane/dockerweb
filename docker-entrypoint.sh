#!/bin/sh

if [ ! -d /var/lib/postgresql/data ];then
    mkdir /var/lib/postgresql/data
fi

# take care of postgres business
chmod 700 /var/lib/postgresql/data
chown -R postgres:postgres /var/lib/postgresql/data
su -s /bin/sh postgres <<EOF
cd
if [ -z $(ls /var/lib/postgresql/data) ];then
    echo 'No data found, initializing postgres.'
    initdb -D data > /dev/null > /dev/null 2>&1
    echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
    sed -i '/unix_socket_directories/d' /var/lib/postgresql/data/postgresql.conf
    echo 'Postgres initialized'
else
    echo "Postgres data found, skipping initialization"
fi
pg_ctl start -D /var/lib/postgresql/data > /dev/null 2>&1
echo 'Postgres Ready'
EOF

# take care of nginx business
if [ ! "$(ls /etc/nginx)" ];then
    echo 'Moving sample into nginx'
    cp -r /sample/nginx/* /etc/nginx
fi
nginx
tail -f /var/log/nginx/access.log &

# take care of redis
redis-server > /dev/null &

# run the cmd
$@