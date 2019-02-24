#!/bin/sh
set -e


if [ "$1" = 'startup' ]; then
	CRON_ENABLE=${CRON_ENABLE:=''}
	CRON_COMMANDS=${CRON_COMMANDS:=''}
	NGINX_ENABLE=${NGINX_ENABLE:=''}
	SUPERVISOR_ENABLE=0

echo $CRON_ENABLE
echo $CRON_COMMANDS
echo $NGINX_ENABLE
echo $SUPERVISOR_ENABLE

	if [ "$CRON_COMMANDS" != '' ]; then
		CRON_ENABLE="1"
	fi
	if [ "$CRON_ENABLE" = '' ]; then
		rm -f /etc/supervisor/conf.d/cron.conf
	else
		SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))
	fi

	if [ "$NGINX_ENABLE" = '' ]; then
		rm -f /etc/supervisor/conf.d/nginx.conf
	else
		SUPERVISOR_ENABLE=$((SUPERVISOR_ENABLE+1))
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
