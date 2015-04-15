
There are some differences between how Solr 4 and 5 invoke configurations.
For Solr 4, you need these instructions:

# How to use this Docker image

To run a single Solr server:

    docker run -d -p 8983:8983 -t makuk66/docker-solr:4.10.4

Then with a web browser go to `http://localhost:8983/solr` to see the Admin Console (adjust the hostname for your docker host).


## Distributed Solr

You can also run a distributed Solr configuration, with Solr nodes in separate containers, sharing a single ZooKeeper server:

Run ZooKeeper, and define a name so we can link to it:

    docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

Run the first Solr node, linked to the zookeeper container, and configured to boostrap its configuration:

    docker run --name solr1 --link zookeeper:ZK -d -p 8983:8983 \
      makuk66/docker-solr:4.10.4 \
      bash -c 'cd /opt/solr/example; java -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'

Then run the second Solr node:

    docker run --name solr2 --link zookeeper:ZK -d -p 8984:8983 \
      makuk66/docker-solr4.10.4 \
      bash -c 'cd /opt/solr/example; java -DzkHost=$ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT -DnumShards=2 -jar start.jar'

Then go to `http://localhost:8983/solr/#/~cloud` (adjust the hostname for your docker host) to see the two shards and Solr nodes.
