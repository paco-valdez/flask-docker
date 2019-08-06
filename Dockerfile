FROM python:2.7.15

LABEL version="1.0"
LABEL author="Francisco Valdez"
LABEL system="Python 2.7.15, Debian"
LABEL description="Docker for api"

ENV cloudwatch=true

RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends libfreetype6-dev \
    libxml2-dev libxslt-dev nginx postgresql-server-dev-all pkg-config -y
RUN apt-get autoclean -y && apt-get autoremove -y



WORKDIR /app
ADD . .
RUN pip install pip -U
RUN pip install --no-cache-dir -r requirements.txt


VOLUME [ "/var/log/app_name", "/var/log/supervisor" ]
RUN \
    mkdir -p /var/log/app_name \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /var/log/supervisord \
    && mkdir -p /etc/nginx/ssl

# Use this with docker in develop
# Supervisor confs
RUN chmod +x /app/app_name/api/conf/api_server.docker.bash
RUN cp app_name/api/conf/api_docker.conf /etc/supervisord.conf
RUN cp app_name/api/conf/api.app_name.com /etc/nginx/sites-available/default
RUN cp app_name/api/conf/nginx_server.conf /etc/nginx/nginx.conf

# RUN cp app_name/api/conf/certs/prod/api.app_name.com.crt /etc/nginx/ssl/api.app_name.com.crt
# RUN cp app_name/api/conf/certs/prod/api.app_name.com.key /etc/nginx/ssl/api.app_name.com.key
EXPOSE 80 443

CMD [ "supervisord" ]
