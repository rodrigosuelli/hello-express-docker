FROM node:20.13.1-alpine

WORKDIR /app

COPY . .

# Use `npm install --production` or `npm install --omit=dev` to skip dev dependencies
RUN npm install

CMD ["npm", "run", "start"]

EXPOSE 3000
