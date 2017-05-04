FROM python:2.7.12

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8
    
RUN apt-get update
RUN apt-get -y install nano
RUN apt-get -y install jpegoptim


COPY db/init.sql /docker-entrypoint-initdb.d/init.sql

RUN mkdir -p /localapp && mkdir -p /data && mkdir -p /scripts
WORKDIR /localapp

COPY fabfile.py /scripts/fabfile.py

RUN apt-get install -y cron

ENV PYTHONPATH /localapp/src/:$PYTHONPATH

COPY scripts/install.sh /scripts/install.sh
COPY scripts/wait-for-postgres.sh /scripts/wait-for-postgres.sh

RUN chmod +x /scripts/install.sh
RUN chmod +x /scripts/wait-for-postgres.sh

RUN DEBIAN_FRONTEND=noninteractive /scripts/install.sh

# Expose ports
# 80 = Ngix
EXPOSE 80
