## Development with Docker
To Develop with docker under linux you have to Export your user-id and group-id by adding th following to your bashrc

    export USER_ID=$(id -u)
    export GROUP_ID=$(id -g)

To access the container user the follwing command:

    docker-compose exec --user ctfluser tooling bash

Run artisan commands in the application container and other commands like composer or npm in the tooling container.

To expose a port to your host add an docker-compose.override.yml like this one:

    version: '3.3'

    networks:
    web:
        external: true
    stack:
        external: false

    services:
    application:
        ports:
            - 8080:80

