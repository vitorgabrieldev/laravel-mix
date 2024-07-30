# Usa uma imagem base oficial do PHP com Apache
FROM php:8.1-apache

# Define o diretório de trabalho
WORKDIR /var/www/html

# Instala as dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia os arquivos da aplicação para o container
COPY . .

# Instala as dependências do Laravel
RUN composer install --no-scripts --no-interaction --prefer-dist

# Define as permissões corretas
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Habilita o mod_rewrite do Apache
RUN a2enmod rewrite

# Exposição da porta 80
EXPOSE 80

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
