#!/bin/sh
set -e

if [ "$1" = 'startup' ]; then
	
	mkdir -p /var/log/php-fpm
	touch /var/log/php-fpm/error.log
	chown -R www-data:www-data /var/log/php-fpm
	chmod 0777 /var/log/php-fpm

	if [ -e /docker-start-hook.sh ]; then
		. /docker-start-hook.sh
	fi

	exec php-fpm;
	
else
	exec "$@"
fi
