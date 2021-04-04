FROM ubuntu:20.04
ENV OS_LOCALE="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=${OS_LOCALE} \
    LC_ALL=${OS_LOCALE} \
	NGINX_CONF_DIR=/etc/nginx

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get install -y \
    php5.6-fpm php5.6-cli php5.6-imagick php5.6-gd php5.6-mysql imagemagick nginx supervisor\
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /var/log/supervisor && \
    mkdir -p /run/php

RUN mkdir /app
COPY src/ /app/ 
COPY conf/supervisord.conf /etc/supervisor/conf.d/
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
