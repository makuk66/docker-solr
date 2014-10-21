Solr on Docker
==============

Run [Solr](http://lucene.apache.org/solr/) on [Docker](https://www.docker.io/).

This repository triggers the [makuk66/docker-solr](https://index.docker.io/u/makuk66/docker-solr/) trusted build on the Docker index.
To run:

    docker pull makuk66/docker-solr
    docker run -p 8983:8983 -t makuk66/docker-solr

Then go to http://docker1.lan:8983/solr (adjust the hostname for your docker server).


You can run SolrCloud too. For example:

    # pull the ZooKeeper image
    docker pull jplock/zookeeper

    # run ZooKeeper, and define a name so we can link to it
    docker run -name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

    # run the first Solr node, with bootstrap parameters, and pass a link parameter to docker
    # so we can use the ZK_* environment variables in the container to locate the ZooKeeper container
    docker run -link zookeeper:ZK -i -p 8983:8983 -t makuk66/docker-solr \
      /bin/bash -c 'cd /opt/solr/example; java -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'

    # in separate sessions, run two more zookeepers
    docker run -link zookeeper:ZK -i -p 8984:8983 -t makuk66/docker-solr \
    /bin/bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'
    docker run -link zookeeper:ZK -i -p 8985:8983 -t makuk66/docker-solr \
    /bin/bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'


Then go to http://docker1.lan:8983/solr/#/~cloud (adjust the hostname for your docker server) to see the two shards and three Solr nodes.
