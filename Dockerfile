FROM php:7.2-fpm-stretch

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive


# Copy files in /root into the image.
COPY /files/ /

RUN set -ex && \
	chmod +x /docker*.sh \
	&& apt-get update -y \
	&& apt-get install -y \
		cron nginx memcached supervisor \
		ssmtp bsd-mailx \
	&& apt-get autoremove

# RUN set -ex \
# 	&& apt-get autoremove \
# 	&& apt-get update -y \
# 	&& apt-get install -y \
# 		cron nginx memcached supervisor \
# 		\
# 		# for sending mail via PHP.
# 		ssmtp bsd-mailx \
# 		\
# 		gosu sudo \
# 		\
# 		# This provides: ps, top, uptime, pkill, watch, etc...
# 		# Reference: https://packages.ubuntu.com/xenial/amd64/procps/filelist
# 		procps \
# 		\
# 		git \
# 		\
# 		libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libxpm-dev libmcrypt-dev imagemagick libmagickwand-dev \
# 		\
# 		# Fix: configure: error: utf8_mime2text() has new signature, but U8T_CANONICAL is missing. This should not happen. Check config.log for additional information.
# 		# Reference: http://www.howtodoityourself.org/fix-error-utf8_mime2text.html
# 		# Reference: https://packages.ubuntu.com/xenial/libdevel/libc-client2007e-dev
# 		libkrb5-dev libc-client2007e-dev krb5-multidev libpam0g-dev libssl-dev \
# 		\
# 		libpspell-dev librecode-dev libtidy-dev libxslt1-dev libgmp-dev libmemcached-dev zip unzip zlib1g-dev \
# 	\
# 	# sendmail setup with SSMTP for mail().
# 	&& echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf \
# 	&& echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini \
#   \
#   && cd /tmp \
#   && curl -o composer-setup.php https://getcomposer.org/installer \
#   && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
#   && rm -f composer-setup.php \
# 	\
#   && docker-php-ext-configure bcmath --enable-bcmath \
#   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include --with-png-dir=/usr/include --with-xpm-dir=/usr/include \
#   && docker-php-ext-configure gmp --with-gmp \
# 	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
#   && docker-php-ext-configure zip --enable-zip \
#   && docker-php-ext-install -j$(nproc) zip gmp bcmath pdo_mysql gd gettext imap intl mysqli opcache pspell recode tidy xsl \
#   \
#   && docker-php-source extract \
#   	&& cd /usr/src/php/ext \
#   	\
#     && curl -fsSL 'http://pecl.php.net/get/imagick' -o imagick.tar.gz \
#     && mkdir -p imagick \
#     && tar -xf imagick.tar.gz -C imagick --strip-components=1 \
# 		&& docker-php-ext-configure imagick --enable-imagick \
# 		&& docker-php-ext-install -j$(nproc) imagick \
#     && rm -r imagick.tar.gz imagick \
#   	\
#     && curl -fsSL 'http://pecl.php.net/get/mcrypt' -o mcrypt.tar.gz \
#     && mkdir -p mcrypt \
#     && tar -xf mcrypt.tar.gz -C mcrypt --strip-components=1 \
# 		&& docker-php-ext-configure mcrypt --enable-mcrypt \
# 		&& docker-php-ext-install -j$(nproc) mcrypt \
#     && rm -r mcrypt.tar.gz mcrypt \
#   	\
#     && curl -fsSL 'http://pecl.php.net/get/memcached' -o memcached.tar.gz \
#     && mkdir -p memcached \
#     && tar -xf memcached.tar.gz -C memcached --strip-components=1 \
# 		&& docker-php-ext-configure memcached \
# 		&& docker-php-ext-install -j$(nproc) memcached \
#     && rm -r memcached.tar.gz memcached \
# 		\
# #		&& git clone https://github.com/websupport-sk/pecl-memcache memcache \
# #		&& docker-php-ext-configure memcache --enable-memcache \
# #		&& docker-php-ext-install -j$(nproc) memcache \
# #		&& rm -r memcache \
# #		\
#   && docker-php-source delete \
#   && true



ENTRYPOINT ["/docker-start.sh"]
CMD ["startup"]
