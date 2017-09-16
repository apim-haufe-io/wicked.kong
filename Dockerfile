FROM kong:0.11.0

ENV KONG_PG_HOST kong-database
ENV KONG_PG_USER kong
ENV KONG_PG_PASSWORD kong
ENV KONG_DATABASE postgres

RUN yum install -y epel-release && yum install -y wget \
    && yum clean all \
    && wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
    && chmod +x /usr/local/bin/dumb-init \
    && wget -O /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/55c54a5abdfb32637b563b28cc088314b162195e/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh \
    && mkdir -p /usr/src/app

COPY templates/nginx_kong.lua /root/nginx_kong.lua
COPY startup.sh /startup.sh
COPY git_* /usr/src/app/

CMD ["/startup.sh"]
