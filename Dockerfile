FROM mapisto/mapisto-front:0.1 as front_build
FROM nginx:1.17.6-alpine
COPY --from=front_build /app/build /usr/share/nginx/html
ADD nginx.conf /etc/nginx/conf.d/default.conf
