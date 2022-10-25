FROM debian:buster-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y apache2 php && a2enmod ssl && mkdir /output && chown -R www-data:www-data output

ENTRYPOINT [ "apachectl", "-D", "FOREGROUND" ]