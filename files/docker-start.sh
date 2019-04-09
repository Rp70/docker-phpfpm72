#!/bin/sh
set -e


if [ "$1" = 'startup' ]; then
	CRON_ENABLE=${CRON_ENABLE:=''}
	CRON_COMMANDS=${CRON_COMMANDS:=''}
	MEMCACHED_ENABLE=${MEMCACHED_ENABLE:=''}
	NGINX_ENABLE=${NGINX_ENABLE:=''}
	NGINX_PROCESSES=${NGINX_PROCESSES:='2'}
	NGINX_REALIP_FROM=${NGINX_REALIP_FROM:=''}
	NGINX_REALIP_HEADER=${NGINX_REALIP_HEADER:=''}
	SUPERVISOR_ENABLE=0

	if [ "$CRON_COMMANDS" != '' ]; then
		CRON_ENABLE="1"
	fi
	if [ "$CRON_ENABLE" = '' ]; then
		rm -f /etc/supervisor/conf.d/cron.conf
	else
		SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))
	fi

	if [ "$MEMCACHED_ENABLE" = '' ]; then
		rm -f /etc/supervisor/conf.d/memcached.conf
	else
		SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))
	fi

	if [ "$NGINX_ENABLE" = '' ]; then
		rm -f /etc/supervisor/conf.d/nginx.conf
	else
		SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))

		#rm -rf /etc/nginx/sites-available/default
		#sed -i 's/^user/daemon off;\nuser/g' /etc/nginx/nginx.conf
		#sed -i 's/^user www-data;/user coin;/g' /etc/nginx/nginx.conf
		sed -i "s/^worker_processes auto;/worker_processes $NGINX_PROCESSES;/g" /etc/nginx/nginx.conf
		#sed -i 's/\baccess_log[^;]*;/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
		#sed -i 's/\berror_log[^;]*;/error_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
	fi

	mkdir -p /var/log/php-fpm
	touch /var/log/php-fpm/error.log
	chown -R www-data:www-data /var/log/php-fpm
	chmod 0777 /var/log/php-fpm

	if [ -e /docker-start-hook.sh ]; then
		. /docker-start-hook.sh
	fi

	if [ "$SUPERVISOR_ENABLE" -gt 0 ]; then
		exec supervisord --nodaemon;
	else
		exec php-fpm --nodaemonize;
	fi
	
else
	exec "$@"
fi
