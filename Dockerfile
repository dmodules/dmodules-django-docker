FROM python:2.7.14

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8
    
RUN apt-get update
RUN apt-get -y install nano
RUN apt-get -y install jpegoptim
RUN apt-get install -y gettext libgettextpo-dev


COPY db/init.sql /docker-entrypoint-initdb.d/init.sql

RUN mkdir -p /localapp && mkdir -p /data && mkdir -p /scripts
WORKDIR /localapp

COPY fabfile.py /scripts/fabfile.py

RUN apt-get install -y cron

ENV PYTHONPATH /localapp/src/:$PYTHONPATH

COPY scripts/install.sh /scripts/install.sh
COPY scripts/wait-for-postgres.sh /scripts/wait-for-postgres.sh
COPY scripts/check scripts/cron_start /usr/local/bin/

RUN chmod +x /scripts/*.sh /usr/local/bin/check /usr/local/bin/cron_start
RUN chmod +x /scripts/install.sh
RUN chmod +x /scripts/wait-for-postgres.sh

# set cron job (USE UTC time)
RUN export CRON="0 21	* * *	root	/scripts/cron_execute.sh"; \
    sed -i -e '/PATH=/a\LC_ALL=C.UTF-8\nLANG=C.UTF-8' -e '/$CRON/d' /etc/crontab; \
    echo "$CRON" >> /etc/crontab

RUN DEBIAN_FRONTEND=noninteractive /scripts/install.sh

# Expose ports
# 80 = Ngix
EXPOSE 80
