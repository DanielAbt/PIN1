FROM node:18.20.4-alpine
WORKDIR /app

ADD package.json package-lock.json /app/
RUN npm install -g npm@10.8.3
RUN npm install

EXPOSE 3000

ADD . /app

CMD ["node", "index"]
