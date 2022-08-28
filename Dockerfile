#--------------------------------------------------------
# Dockerfile to build Imgage of WebMail service
#
# Made by h963z57 16-Aug-2022
#--------------------------------------------------------

FROM debian:latest 

COPY conf /conf

RUN cp /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime \ 
		&& apt-get update \
		&& apt-get install -y \ 
			ca-certificates \
			apt-transport-https \
			software-properties-common \
			wget \
			curl \
			nginx \
			gpg \
			lsb-release \
				&& wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
				&& sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
					&& apt-get update \
					&& apt-get install -y \
						php8.0-fpm \
						php8.0-mbstring \
						php8.0-zip \
						php8.0-xml \
						php8.0-mysql \
						php8.0-pdo \
						php8.0-intl \
						php-pear \
 							&& echo "timezone = Asia/Yekaterinburg" >> /etc/php/8.0/php.ini \ 
								&& wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz \
								&& tar xvf roundcubemail-1.6.0-complete.tar.gz --strip-components=1 -C /var/www/html/ \
								&& rm roundcubemail-1.6.0-complete.tar.gz \
								&& rm -R /var/www/html/installer \
									&& mv /conf/entrypoint.sh /entrypoint.sh \
									&& mv /conf/nginx.conf /etc/nginx/nginx.conf \
									&& mv /conf/config.inc.php /var/www/html/config/config.inc.php \
									&& rm -R /conf \
										&& chown -R www-data:www-data /var/www/html \
										&& chmod -R 500 /var/www/html \
										&& chmod -R 700 /var/www/html/temp/ \
										&& chmod 400 /var/www/html/config/config.inc.php \
											&& chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80


###									&& mkdir /var/www/html/tmp \