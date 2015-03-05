#!/bin/bash

volume=".:/var/www"
newVolume="./tmp-project:/var/www"

install_dependencies() {
    mkdir tmp-project
    sed -i 's|'$volume'|'$newVolume'|' docker-compose.yml

    docker-compose up -d --no-deps data
    docker-compose run --rm composer require --dev --no-interaction --prefer-dist "phpunit/phpunit:~4.4" "codeception/codeception:~2.0"
    docker-compose stop
    docker-compose rm --force

    sed -i 's|'$newVolume'|'$volume'|' docker-compose.yml
    cp -Rf tmp-project/* ./
    sudo rm -rf tmp-project
}

install_dependencies

# Init services
docker-compose up -d data dbData db dbAmbassador php phpAmbassador server

# Set up database
#docker-compose run --rm console doctrine:database:create
sleep 60 && docker-compose run --rm console doctrine:phpcr:init:dbal
docker-compose run --rm console doctrine:phpcr:repository:init
docker-compose run --rm console doctrine:phpcr:f:ixtures:load
