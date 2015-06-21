# Apache2 container
FROM ubuntu:12.04
RUN apt-get update && apt-get install -y telnetd && apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80
CMD ["/usr/sbin/bash"]

