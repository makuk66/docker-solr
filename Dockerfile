#
# VERSION 0.2

FROM    ubuntu
MAINTAINER  Martijn Koster "mak-docker@greenhills.co.uk"

ENV SOLR solr-4.6.0
RUN mkdir -p /opt
ADD $SOLR.tgz /opt/$SOLR.tgz
RUN tar -C /opt --extract --file /opt/$SOLR.tgz
RUN ln -s /opt/$SOLR /opt/solr

RUN apt-get update
RUN apt-get --yes install openjdk-6-jdk
EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"]
