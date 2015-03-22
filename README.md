# What is Solr

Solr is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more. Solr powers the search and navigation features of many of the world's largest internet sites.

Learn more on [Apache Solr homepage](http://lucene.apache.org/solr/) and in the [Apache Solr Reference Guide](https://www.apache.org/dyn/closer.cgi/lucene/solr/ref-guide/).


# How to use this image

To run a single Solr server:

    docker run -it -p 8983:8983 -t makuk66/docker-solr

Then with a web browser go to http://localhost:8983/solr to see the Admin Console (adjust the hostname for your docker host).


## Single-container SolrCloud

To simulate a distributed Solr configuration ("SolrCloud" mode) in a single container, run the "cloud" example:

    docker run -it -p 8983:8983 -p 7574:7574 makuk66/docker-solr \
        /bin/bash -c "/opt/solr/bin/solr -e cloud -noprompt; echo hit return to quit; read"


## Distributed Solr

You can also run a distributed Solr configuration, with Solr nodes in separate containers, sharing a single ZooKeeper server:

    # pull the ZooKeeper image
    docker pull jplock/zookeeper

    # run ZooKeeper, and define a name so we can link to it
    docker run -name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

    # run the first Solr node, with bootstrap parameters, and pass a link parameter to docker
    # so we can use the ZK_* environment variables in the container to locate the ZooKeeper container
    docker run -link zookeeper:ZK -i -p 8983:8983 -t makuk66/docker-solr \
      /bin/bash -c 'cd /opt/solr/example; java -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'

    # in separate sessions, run two more solr nodes
    docker run -link zookeeper:ZK -i -p 8984:8983 -t makuk66/docker-solr \
    /bin/bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'
    docker run -link zookeeper:ZK -i -p 8985:8983 -t makuk66/docker-solr \
    /bin/bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'

Then go to http://localhost:8983/solr/#/~cloud (adjust the hostname for your docker host) to see the two shards and three Solr nodes.

# License

Solr is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0), and this repository is too.

# About this repository

The Dockerfile for this repository is available on [github.com/makuk66/docker-solr](https://github.com/makuk66/docker-solr/blob/master/Dockerfile), and the automated build is on the [Docker Registry](https://registry.hub.docker.com/u/makuk66/docker-solr/).

# Supported Docker versions

This image has been tested with Docker version 1.5.0.

# User Feedback

## Issues

If you have any problems with or questions about this image, please submit a [GitHub issue](https://github.com/makuk66/docker-solr/issues).

## Contributing

If you have have a contribution for this repository, please send a pull request.

If you want to contribute to Solr, see the [Solr Resources](http://lucene.apache.org/solr/resources.html).
