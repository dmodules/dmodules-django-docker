FROM python:2.7.12

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN mkdir -p /localapp && mkdir -p /data
WORKDIR /localapp

ENV PYTHONPATH /localapp/src/:$PYTHONPATH


#RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >/etc/apt/sources.list.d/pgdg.list
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
#RUN apt-get update
#RUN apt-get -y install postgresql-client

#ADD scripts/backup.sh /usr/local/bin/backup
#RUN chmod +x /usr/local/bin/backup

COPY db/init.sql /docker-entrypoint-initdb.d/init.sql

COPY . /localapp

ADD requirements.txt /localapp/
RUN pip install -r requirements.txt

# Expose ports
# 8000 = Gunicorn
# 3306 = MySQL
EXPOSE 8000 5432

# collectstatic
# -------------
RUN DJANGO_MODE=build python manage.py collectstatic --noinput
#RUN DJANGO_MODE=build python manage.py migrate

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*