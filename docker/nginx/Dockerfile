FROM nginx:1.13

ADD etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/certs/ /etc/nginx/ssl/
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN addgroup --gid 1000 docker
RUN usermod -a -G docker nginx

ENV SERVER_NAME dvdlkm2.test
ENV UPLOAD_MAX_FILESIZE 64M
ENV MAGENTO_ROOT /var/www/magento/src
ENV MAGENTO_RUN_MODE production
ENV DEBUG false

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN mkdir /sock

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
