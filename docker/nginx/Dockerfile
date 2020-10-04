FROM nginx:1.13

ADD etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/certs/ /etc/nginx/ssl/
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN addgroup --gid 1000 docker
RUN usermod -a -G docker nginx

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN mkdir /sock

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
