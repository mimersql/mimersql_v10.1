FROM debian:latest
CMD ["bash"]
ADD mimersql1014_10.1.4F-27325_amd64.deb /mimersql/mimersql1014_10.1.4F-27325_amd64.deb
WORKDIR /mimersql
RUN apt-get update \
    && apt-get install -y zenity systemd xinetd
RUN dpkg -i mimersql1014_10.1.4F-27325_amd64.deb
RUN dbinstall -dil -u root mimerdb SYSADM /usr/local/MimerSQL
EXPOSE 1360
ENTRYPOINT service xinetd start \
    && mimexper mimerdb