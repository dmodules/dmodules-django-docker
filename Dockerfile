FROM python:2.7.12

ENV PYTHONUNBUFFERED=1 \
    PIP_REQUIRE_VIRTUALENV=false \
    PATH=/virtualenv/bin:/root/.local/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN mkdir /localapp
WORKDIR /localapp

ENV PYTHONPATH /localapp/src/:$PYTHONPATH

VOLUME /data

COPY . /localapp

ADD requirements.txt /localapp/
RUN pip install -r requirements.txt

ENV PIP_PRE=1 \
    DATA_ROOT=/data

# Expose ports
# 8000 = Gunicorn
# 3306 = MySQL
EXPOSE 8000 5432

# collectstatic
# -------------
RUN DJANGO_MODE=build python manage.py collectstatic --noinput

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*