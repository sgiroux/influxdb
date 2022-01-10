

FROM influxdb:1.8.4

RUN apt-get update
RUN apt-get install -y unzip cron vim
WORKDIR /tmp

# Install AWS cli for backup/restore
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
RUN unzip awscliv2.zip
RUN ./aws/install

# Set up cron jobs for backup to run at 3am everyday
RUN echo '0 3 * * * /usr/local/bin/backup.sh >> /tmp/backup.log' >> /var/spool/cron/crontabs/root

ADD backup.sh /usr/local/bin/
ADD restore.sh /usr/local/bin/
ADD startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/restore.sh
RUN chmod +x /usr/local/bin/startup.sh

#CMD ["service cron start && influxd"]

CMD ["/usr/local/bin/startup.sh"]