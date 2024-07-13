ARG NGINX_PORT=80
ARG NGINX_VERSION=1.27.0
FROM nginx:$NGINX_VERSION-alpine
RUN rm /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE $NGINX_PORT

CMD ["nginx", "-g", "daemon off;"]