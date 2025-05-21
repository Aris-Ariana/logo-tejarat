FROM nginx:alpine

RUN chgrp -R 0 /var/cache/nginx /var/run /etc/nginx /usr/share/nginx/html && \
    chmod -R g=u /var/cache/nginx /var/run /etc/nginx /usr/share/nginx/html

COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
