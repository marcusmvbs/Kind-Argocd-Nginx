# syntax=docker/dockerfile:1

FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000

# 1- docker volume create todo-db
# 2- docker build -t 21121953/py_spark .
# 3- docker login
# 4- docker push 21121953/py_spark
# 5- docker run -dp 127.0.0.1:3000:3000 --mount type=volume,src=todo-db,target=/etc/tododir 21121953/py_spark
# 6- docker exec -it 2cd9114f7de5
# ---
# 6- docker network create todo-app
# 5- docker run -d --network todo-app --network-alias mysql -v todo-mysql-data:/var/lib/mysql \
#               -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos mysql:8.0
# 6- docker exec -it <container_id> mysql -u root -p