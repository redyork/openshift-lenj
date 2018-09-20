FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y -qq cron certbot nginx git curl mc net-tools && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/letsencrypt && chmod 777 /data/letsencrypt \
    && mkdir -p /var/jenkins_home && chmod -R 777 /var/jenkins_home \
    && mkdir -p /var/cache/nginx/ \
    && chmod -R 777 /var/log/nginx /var/cache/nginx/ \
    && chmod +rwx /var/run \
    && chgrp -R 0 /var/cache/nginx /var/lib/nginx /var/log/nginx \
    && chmod -R g=u /var/cache/nginx /var/lib/nginx /var/log/nginx \
    && sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf \
    && sed -i 's,/run/nginx.pid,/var/cache/nginx/nginx.pid,g' /etc/nginx/nginx.conf \
    && chmod +rwx /var/jenkins_home \
    && chgrp -R 0 /var/jenkins_home \
    && chmod -R g=u /var/jenkins_home \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log 

COPY jenkins.sh /usr/local/bin/jenkins2.sh

EXPOSE 8088
EXPOSE 8448

COPY start.sh /usr/local/bin/start.sh
COPY nginx/dhparam-2048.pem /etc/nginx/dhparam-2048.pem
COPY nginx/nginx_http.conf /etc/nginx/nginx_http.conf
COPY nginx/nginx_http.conf /etc/nginx/sites-enabled/default
COPY nginx/nginx_ssl.conf /etc/nginx/nginx_ssl.conf
COPY certbot/certs_update.sh /root/certs_update.sh
COPY certbot/install_certs.sh /root/install_certs.sh

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/start.sh"]
