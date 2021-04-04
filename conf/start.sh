#!/usr/bin/env sh

chmod 777 /storage
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
