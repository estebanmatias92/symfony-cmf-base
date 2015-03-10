#!/bin/bash

# Init services
docker-compose up -d data dbData db dbAmbassador php phpAmbassador server

# Install project
docker-compose run --rm composer require --dev --no-interaction --prefer-dist "phpunit/phpunit:~4.4" "codeception/codeception:~2.0"

sleep 60

cp pre-defined-config/app/config/parameters.yml app/config/parameters.yml
rm -rf pre-defined-config

# Set up database
#docker-compose run --rm console doctrine:database:create
docker-compose run --rm console doctrine:phpcr:init:dbal
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console --no-interaction doctrine:phpcr:fixtures:load
