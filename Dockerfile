FROM ubuntu:16.04

RUN apt-get update -y

RUN mkdir -p /var/www

# Installs Utils
RUN apt-get install build-essential unzip libaio1 curl git git-core nfs-common cifs-utils software-properties-common vim -y

# Installs Nginx
RUN apt-get install nginx -y

#RUN add-apt-repository ppa:ondrej/php -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php -y
RUN apt-get update -y

# Installs PHP 7.1
RUN apt-get install php7.1 php7.1-cli php7.1-fpm php7.1-mysql php7.1-xml php7.1-mcrypt php7.1-curl php7.1-dev php7.1-mbstring -y

# Install Supervisord
RUN apt-get install supervisor -y
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# Enables mcrypt
# RUN php5enmod mcrypt

# Installs Composer
RUN apt-get install composer -y

# Install MySQL
# RUN apt-get install mysql-server -y

# Set up site
COPY default.site /etc/nginx/sites-available/default

# Forces reload
RUN echo "sudo /etc/init.d/nginx start" | tee -a /etc/rc.local

# -v /path/to/passport/laravel:/var/www/laravel
VOLUME ["/var/www/laravel"]

WORKDIR /var/www/laravel

EXPOSE 80

# ENTRYPOINT service nginx start && service php7.1-fpm start

# CMD tail -f /dev/null

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]