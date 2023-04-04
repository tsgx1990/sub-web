# ---- Dependencies ----
FROM node:16-alpine AS dependencies
WORKDIR /app
COPY package.json ./
RUN yarn install

# ---- Build ----
FROM dependencies AS build
WORKDIR /app

# API 后端
ENV VUE_APP_SUBCONVERTER_DEFAULT_BACKEND="https://api.wcc.best"
# 短链接后端
ENV VUE_APP_MYURLS_DEFAULT_BACKEND="https://suo.yt"

COPY . /app
RUN yarn build

FROM nginx:1.16-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
