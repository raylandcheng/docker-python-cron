# this is an official Python runtime, used as the parent image
FROM python:3.8-slim-buster as base

# install cron (and if necessary nano)


# # install oracle instantclient for linux
# WORKDIR    /app/oracle_client
# RUN        apt-get update && apt-get install -y libaio1 wget unzip \
#             && wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip \
#             && unzip instantclient-basiclite-linuxx64.zip \
#             && rm -f instantclient-basiclite-linuxx64.zip \
#             && cd /app/oracle_client/instantclient* \
#             && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci \
#             && echo /app/oracle_client/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf \
#             && ldconfig


# set the working directory in the container to /
WORKDIR /app

# add the current directory to the container as /
COPY . /app

# change permission to allow app.sh to execute
RUN ["chmod", "+x", "/app/app.sh"]

RUN apt-get update && apt-get -y --no-install-recommends install cron \
    && rm -rf /var/lib/apt/lists/*
# set a cronjob to run app.sh at 8pm. ""> /proc/1/fd/1 2>/proc/1/fd/2" outputs to log.
# RUN echo "0 20 * * * root /app/app.sh > /proc/1/fd/1 2>/proc/1/fd/2" >> /etc/crontab
# RUN echo "*/1 * * * * root /app/app.sh > /proc/1/fd/1 2>/proc/1/fd/2" >> /etc/crontab


RUN echo "$(cat cronjob)" >> /etc/crontab

# runs the pip install for the app dependencies
# RUN pip install --upgrade pip
# RUN pip install -r requirements.txt

# sets cron as the run job in container
ENTRYPOINT ["cron", "-f"]
