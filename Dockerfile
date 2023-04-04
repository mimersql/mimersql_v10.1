# This Docker image is based on debian
FROM debian:latest

# update and install necessary utilities
RUN apt-get update && \
    apt-get install -y sudo file procps systemd xinetd wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# set the name of the package
ENV debfile mimersql1016_10.1.6D-36610_amd64.deb

# fetch the package and install it
RUN wget https://download.mimer.com/pub/dist/linux_x64/${debfile} && \
    dpkg --ignore-depends=zenity  --install ${debfile}

# create a new, empty database
RUN dbinstall -dil -u root mimerdb SYSADM /usr/local/MimerSQL

# export the database port
EXPOSE 1360

# copy the start script and launch Mimer SQL
COPY start.sh /
CMD [ "/start.sh" ]
