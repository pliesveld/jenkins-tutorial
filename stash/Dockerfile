FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	nginx \
	apache2-utils \
	curl \
	git-core \
	fcgiwrap \
	spawn-fcgi 

RUN rm -rf /etc/nginx/sites-enabled/default
RUN htpasswd -b -c /etc/nginx/.htpasswd user password
RUN htpasswd -b -c /etc/nginx/.htpasswd_admin admin password

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443
CMD spawn-fcgi -u www-data -s /var/run/fcgiwrap.socket /usr/sbin/fcgiwrap && nginx -g "daemon off;"
