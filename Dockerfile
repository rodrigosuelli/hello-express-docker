# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# copy package.json and package-lock.json to the working directory
# This is done before copying the rest of the files to take advantage of Docker’s cache
# If the package.json and package-lock.json files haven’t changed, Docker will use the cached dependencies
COPY package*.json .

# install dependencies
# Use `npm install --omit=dev` to skip dev dependencies
RUN npm install --omit=dev

# copy the rest of the files to the working directory
COPY . .

# RUN npm run build

# Production stage
FROM gcr.io/distroless/nodejs20-debian12 AS production

WORKDIR /app

COPY package*.json .

COPY --from=build /app/node_modules ./node_modules
# COPY --from=prod-deps /app/node_modules ./node_modules
# COPY --from=build /app/dist ./dist
COPY --from=build /app/src ./src
COPY --from=build /app/package.json ./package.json

# expose port 3000 to tell Docker that the container listens on the specified network ports at runtime
EXPOSE 3000

# command to run the app
# with distroless image just use the name of the main file
CMD ["src/server.js"]
# CMD ["npm", "run", "start"]
