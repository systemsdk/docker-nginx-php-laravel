#!/bin/bash -x

if [ "$ENV" == "dev" ] || [ "$ENV" == "test" ]; then
    pecl install xdebug-$XDEBUG_VERSION
    mv /tmp/xdebug.ini /usr/local/etc/php/conf.d/
else
    rm /tmp/xdebug.ini
fi
