#!/bin/bash

if [ -z "$1" ]; then
    DEPLOY_ENV="dev"
else
    DEPLOY_ENV="$1"
fi

# Init services
docker-compose up -d data dbData db dbAmbassador php phpAmbassador server

# Delay to give to the db container install everything
sleep 60s

# Install project dependencies
if [ "$DEPLOY_ENV" == "dev" ]; then
    docker-compose run --rm composer update --no-interaction --prefer-dist
fi

if [ "$DEPLOY_ENV" == "prod" ]; then
    docker-compose run --rm composer install --no-scripts --no-dev --no-interaction --prefer-dist
fi

# Set up database
#docker-compose run --rm console doctrine:database:create
docker-compose run --rm console doctrine:phpcr:init:dbal
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console doctrine:phpcr:fixtures:load