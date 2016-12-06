FROM python:2.7.12

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN mkdir -p /localapp && mkdir -p /data
WORKDIR /localapp

ENV PYTHONPATH /localapp/src/:$PYTHONPATH

COPY . /localapp
COPY db/init.sql /docker-entrypoint-initdb.d/init.sql

RUN chmod 777 /localapp/scripts/install.sh

RUN DEBIAN_FRONTEND=noninteractive /localapp/scripts/install.sh


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