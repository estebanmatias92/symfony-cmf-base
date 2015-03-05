#!/bin/bash

# Init services
docker-compose up -d data dbData db dbAmbassador php phpAmbassador server

# Install project
docker-compose run --rm composer require --dev --no-interaction --prefer-dist "phpunit/phpunit:~4.4" "codeception/codeception:~2.0"

# Set up database
#docker-compose run --rm console doctrine:database:create
sleep 60 && docker-compose run --rm console doctrine:phpcr:init:dbal
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console doctrine:phpcr:fixtures:load
