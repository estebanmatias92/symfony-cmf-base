#!/bin/bash

if [ -z "$1" ]; then
    DEPLOY_ENV="dev"
else
    DEPLOY_ENV="$1"
fi

# Config docker-compose.yml
sed -i 's|{project_name}|'$(basename $(pwd))'|g' docker-compose.yml

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
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console --no-interaction doctrine:phpcr:fixtures:load
