#!/bin/sh

# take care of postgres business
su -s /bin/sh postgres <<EOF
cd
if [ ! -d data ];then
    echo 'No data found, initializing postgres.'
    mkdir data
    chmod 700 data
    initdb -D data > /dev/null 2> /dev/null
    echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
    sed -i '/unix_socket_directories/d' /var/lib/postgresql/data/postgresql.conf
    echo 'Postgres initialized'
fi
pg_ctl start -D /var/lib/postgresql/data > /dev/null
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