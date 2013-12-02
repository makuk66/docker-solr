Solr on Docker
==============

Run [Solr](http://lucene.apache.org/solr/) on [Docker](https://www.docker.io/).

This repository triggers the [makuk66/docker-solr](https://index.docker.io/u/makuk66/docker-solr/) trusted build on the Docker index.
To run:

    docker pull makuk66/docker-solr
    docker run -p 8983 -t makuk66/docker-solr /bin/bash -c "cd /opt/solr/example; java -jar start.jar"
