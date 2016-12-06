FROM python:2.7.12

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

COPY db/init.sql /docker-entrypoint-initdb.d/init.sql

RUN mkdir -p /localapp && mkdir -p /data
WORKDIR /localapp

COPY fabfile.py /localapp/fabfile.py

ENV PYTHONPATH /localapp/src/:$PYTHONPATH

COPY scripts/install.sh /localapp/scripts/install.sh
COPY scripts/wait-for-postgres.sh /localapp/scripts/wait-for-postgres.sh

RUN chmod +x /localapp/scripts/install.sh

RUN DEBIAN_FRONTEND=noninteractive /localapp/scripts/install.sh

# Expose ports
# 8000 = Gunicorn
# 3306 = MySQL
EXPOSE 8000 5432


