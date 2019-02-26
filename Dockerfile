FROM armhf/alpine as builder
RUN apk --update add nodejs
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM mariusrumpf/rpi-nginx
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]