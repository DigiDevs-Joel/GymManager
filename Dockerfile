# Use official PHP 7.4 CLI base image
FROM php:7.4-cli

# Install dependencies for Laravel/MotionGym
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-install zip pdo_mysql bcmath

# Set working directory
RUN apt-get install -y libonig-dev
WORKDIR /app

# Copy project files
COPY . /app
RUN cp .env.example .env && sed -i 's/DB_HOST=127.0.0.1/DB_HOST=host.docker.internal/g' .env

# Install Composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-scripts --optimize-autoloader

# Expose port if running a server
EXPOSE 8000

# Default command: Start Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
