FROM      python:3.6.4-slim

RUN       apt-get -y update
RUN       apt-get -y dist-upgrade

RUN       apt-get -y install nginx supervisor

# File copy
COPY      . /srv/backend
WORKDIR   /srv/backend
RUN       pip install -r requirements.txt

# Copy Nginx conf
RUN      rm -rf  /etc/nginx/sites-enabled/*
# Nginx conf
RUN      cp -f /srv/backend/.config/nginx.conf \
               /etc/nginx/nginx.conf


# Copy Nginx application conf

RUN      cp -f /srv/backend/.config/nginx-app.conf \
               /etc/nginx/sites-available/
RUN      ln -sf /etc/nginx/sites-available/nginx-app.conf \
                /etc/nginx/sites-enabled/nginx-app.conf

# Copy supervisor conf
RUN     cp -f /srv/backend/.config/superviosrd.conf \
              /etc/supervisor/conf.d

# Stop Nginx, Run supervisor
CMD    pkill nginx; supervisor -n
EXPOSE    80
