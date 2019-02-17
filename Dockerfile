FROM php:7.3-fpm

# set main params
ARG BUILD_ARGUMENT_DEBUG_ENABLED=false
ENV DEBUG_ENABLED=$BUILD_ARGUMENT_DEBUG_ENABLED
ARG BUILD_ARGUMENT_APP_ENV=development
ENV APP_ENV=$BUILD_ARGUMENT_APP_ENV
ARG BUILD_ARGUMENT_ENV_FILE=.env.local
ENV ENV_FILE=$BUILD_ARGUMENT_ENV_FILE
ENV APP_HOME /var/www/html

# check environment
RUN if [ "$BUILD_ARGUMENT_APP_ENV" = "default" ]; then echo "Set BUILD_ARGUMENT_APP_ENV in docker build-args like --build-arg BUILD_ARGUMENT_APP_ENV=development" && exit 2; \
    elif [ "$BUILD_ARGUMENT_APP_ENV" = "development" ]; then echo "Building development environment."; \
    elif [ "$BUILD_ARGUMENT_APP_ENV" = "production" ]; then echo "Building production environment."; \
    else echo "Set correct BUILD_ARGUMENT_APP_ENV in docker build-args like --build-arg BUILD_ARGUMENT_APP_ENV=development. Available choices are development,production." && exit 2; \
    fi

# install all the dependencies and enable PHP modules
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      libzip-dev \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      pdo_mysql \
      intl \
      zip && \
      rm -fr /tmp/* && \
      rm -rf /var/list/apt/* && \
      rm -r /var/lib/apt/lists/* && \
      apt-get clean

# create document root
RUN mkdir -p $APP_HOME/public

# change owner
RUN chown -R www-data:www-data $APP_HOME

# put php config for Laravel
COPY ./docker/$BUILD_ARGUMENT_APP_ENV/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/$BUILD_ARGUMENT_APP_ENV/php.ini /usr/local/etc/php/php.ini

# install Xdebug in case development environment
COPY ./docker/other/do_we_need_xdebug.sh /tmp/
COPY ./docker/development/xdebug.ini /tmp/
RUN chmod u+x /tmp/do_we_need_xdebug.sh && /tmp/do_we_need_xdebug.sh $BUILD_ARGUMENT_APP_ENV

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# add supervisor
RUN mkdir -p /var/log/supervisor
COPY --chown=root:root ./docker/other/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=root:root ./docker/other/cron /var/spool/cron/crontabs/root
RUN chmod 0600 /var/spool/cron/crontabs/root

# set working directory
WORKDIR $APP_HOME

# create composer folder for user www-data
RUN mkdir -p /var/www/.composer && chown -R www-data:www-data /var/www/.composer

USER www-data

# copy source files and config file
COPY --chown=www-data:www-data . $APP_HOME/
COPY --chown=www-data:www-data $ENV_FILE $APP_HOME/.env

# install all PHP dependencies
RUN if [ "$BUILD_ARGUMENT_APP_ENV" = "development" ]; then composer install --no-interaction --no-progress; \
    else composer install --no-interaction --no-progress --no-dev; \
    fi

USER root
