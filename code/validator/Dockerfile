FROM mhart/alpine-node:5
WORKDIR /src

RUN npm install starsky ajv

ADD . .
EXPOSE 3000
CMD ["node", "index.js"]
