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
    php5.6-fpm php5.6-cli php5.6-imagick php5.6-gd php5.6-mysql php5.6-curl php5.6-dom imagemagick nginx supervisor curl\
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /var/log/supervisor && \
    mkdir -p /run/php

RUN mkdir /app
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stderr /var/log/php5.6-fpm.log
COPY src/ /app/ 
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/nginx.conf /etc/nginx/
COPY conf/start.sh /

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN chmod 700 /start.sh
WORKDIR /app
RUN composer install --no-dev
EXPOSE 80
CMD ["/start.sh"]
