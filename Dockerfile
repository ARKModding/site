# This file is only used for local dev and PR builds
FROM node:18-alpine AS base
WORKDIR /app
RUN apk update && apk upgrade

FROM base AS dev

COPY yarn.lock package.json ./
RUN yarn set version stable && yarn install

ENTRYPOINT ["yarn", "run", "start", "--host=0.0.0.0", "--port=3000"]

FROM base AS build

COPY . .
RUN yarn install --immutable && yarn build

FROM nginx:alpine AS final

COPY --from=build /app/build /usr/share/nginx/html
