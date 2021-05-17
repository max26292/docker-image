Tutorial
===

#### build  

1. Copy sample.env to .env
1. Change these value to required value of project
    ```
        COMPOSE_PROJECT_NAME=''
        DB_DATABASE=engage
        DB_USERNAME=engage
        DB_PASSWORD=engage
        DB_HOST=${COMPOSE_PROJECT_NAME}_db_1
        DB_EXTERNAL_PORT=3307
        IP_PREFIX=172.121.0
        PHP_VER=7.4
        SOURCE_PATH=''
        WEB_PORT=81
    ```
1. run this command to build necessary image for all project  
    ```docker-compose --file docker-compose-build.yml build```
1. After that run once of these commands to create network
    - ``` docker-compose up -d ```
    - ``` docker network create -d bridge app-network```
    - **Make sure you understand what you want when change these 

---

#### Start project

> ON project_1 folder is example for a project run with docker-compose
> run these command below to 