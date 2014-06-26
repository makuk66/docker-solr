
FROM    makuk66/docker-oracle-java7
MAINTAINER  Martijn Koster "mak-docker@greenhills.co.uk"

ENV SOLR_VERSION 4.9.0
ENV SOLR solr-$SOLR_VERSION
RUN mkdir -p /opt
ADD http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz /opt/$SOLR.tgz
RUN tar -C /opt --extract --file /opt/$SOLR.tgz
RUN ln -s /opt/$SOLR /opt/solr

EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"]
