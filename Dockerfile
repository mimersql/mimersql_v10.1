# This Docker image is based on debian
FROM debian:latest

# update and install necessary utilities
RUN apt-get update \
    && apt-get install -y zenity systemd xinetd wget

# set the name of the package
ENV debfile mimersql1014_10.1.4F-27325_amd64.deb

# fetch the package and install it
RUN wget http://ftp.mimer.com/pub/dist/linux_x64/${debfile}
RUN dpkg -i ${debfile}

# create a new, empty database
RUN dbinstall -dil -u root mimerdb SYSADM /usr/local/MimerSQL

# export the database port
EXPOSE 1360

# copy the start script and launch Mimer SQL
COPY start.sh /
CMD [ "/start.sh" ]
