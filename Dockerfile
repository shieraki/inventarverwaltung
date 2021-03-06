FROM php:7.3-apache-stretch

# Set apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN mkdir ${APACHE_DOCUMENT_ROOT}
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set Apache server name
RUN echo 'ServerName inventar.chaostreff-flensburg.de' >> /etc/apache2/apache2.conf

# Activate mod_rewrite
RUN a2enmod rewrite

# Update all packages
RUN apt-get update -y
RUN apt-get install -y libzip-dev
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y gnupg
RUN apt-get install -y git

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

WORKDIR /var/www/html

COPY . .

# Install Composer
RUN cd ~
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer

# Install Node.js
RUN cd ~
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Restart apache
RUN apachectl restart

# Install application
RUN composer install --optimize-autoloader --no-suggest --no-interaction
RUN npm install
RUN npm run production

# Set permissions
RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache
