#multistage script
#stage 1
FROM node:19-alpine3.15 as build
WORKDIR /app
COPY package*.json /app/
COPY . .
RUN npm run build

#stage 2
FROM node:19-alpine3.15
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3000
CMD [ "npm", "start" ]