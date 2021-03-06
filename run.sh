#!/bin/bash

set -e

function setEnvironmentVariable() {
    if [ -z "$2" ]; then
            echo "Environment variable '$1' not set."
            return
    fi
    echo "env[$1] = \"$2\"" >> /etc/php-fpm.d/www.conf
}

# Grep all ENV variables
# for _curVar in `env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    # setEnvironmentVariable ${_curVar} ${!_curVar}
# done

# prepare log output
mkdir -p /app/runtime/logs /app/web/assets
touch /var/log/nginx/access.log \
      /var/log/nginx/error.log \
      /app/runtime/logs/web.log \
      /app/runtime/logs/console.log
# adjust folder permissions for docker volume usage
# find /app/runtime -type d -print0 | xargs -0 chmod 777
# find /app/runtime -type f -print0 | xargs -0 chmod 666
# find /app/web/assets -type d -print0 | xargs -0 chmod 777
# find /app/web/assets -type f -print0 | xargs -0 chmod 666

# generate example
[[ -z $(ls /views) ]] && cp -r /views.example/* /views

# start PHP and nginx
service php-fpm start
service sshd start
service nginx start
# nginx -g "daemon off;"
