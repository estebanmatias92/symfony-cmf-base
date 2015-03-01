#!/bin/bash

# Init services
docker-compose up -d data dbData db dbAmbassador php phpAmbassador server

# Delay to give to the db container install everything
sleep 60s

# Install project dependencies
docker-compose run --rm composer require --dev --no-update "phpunit/phpunit:~4.4" "codeception/codeception:~2.0"
docker-compose run --rm composer update --no-interaction --prefer-dist

# Set up database
#docker-compose run --rm console doctrine:database:create
docker-compose run --rm console doctrine:phpcr:init:dbal
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console doctrine:phpcr:fixtures:load
