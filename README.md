
![Solr Logo](logo.png)

# What is Solr?
Solr is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more. Solr powers the search and navigation features of many of the world's largest internet sites.

Learn more on [Apache Solr homepage](http://lucene.apache.org/solr/) and in the [Apache Solr Reference Guide](https://www.apache.org/dyn/closer.cgi/lucene/solr/ref-guide/).


# How to use this image

To run a single Solr server:

    docker run -d -p 8983:8983 -t makuk66/docker-solr

Then with a web browser go to `http://localhost:8983/solr` to see the Admin Console (adjust the hostname for your docker host).


## Single-container SolrCloud

To simulate a distributed Solr configuration ("SolrCloud" mode) in a single container, run the "cloud" example:

    docker run -it -p 8983:8983 -p 7574:7574 makuk66/docker-solr \
        /bin/bash -c "/opt/solr/bin/solr -e cloud -noprompt; echo hit return to quit; read"


## Distributed Solr

You can also run a distributed Solr configuration, with Solr nodes in separate containers, sharing a single ZooKeeper server:

Run ZooKeeper, and define a name so we can link to it:

    docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

Run two solr nodes, linked to the zookeeper container:

    docker run --name solr1 --link zookeeper:ZK -d -p 8983:8983 makuk66/docker-solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

    docker run --name solr2 --link zookeeper:ZK -d -p 8984:8983 makuk66/docker-solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

Create a collection:

    docker exec -i -t solr1 /opt/solr/bin/solr create_collection -c collection1 -shards 2 -p 8983

Then go to `http://localhost:8983/solr/#/~cloud` (adjust the hostname for your docker host) to see the two shards and Solr nodes.

# About this repository

This repository is available on [github.com/makuk66/docker-solr](https://github.com/makuk66/docker-solr), and the automated build is on the [Docker Registry](https://registry.hub.docker.com/u/makuk66/docker-solr/).

## Supported tags

This README describes the latest version, available under he `latest` tag, with [this Dockerfile](https://github.com/makuk66/docker-solr/blob/master/Dockerfile).

Other tags:

4.10.3 ([Dockerfile](https://github.com/makuk66/docker-solr/blob/151e7f03b97d61d9ce4f701f9d8f92d183eb4831/Dockerfile). Use the [old instructions](https://github.com/makuk66/docker-solr/tree/151e7f03b97d61d9ce4f701f9d8f92d183eb4831))

## Supported Docker versions

This image has been tested with Docker version 1.5.0.

# User Feedback

## Issues

If you have any problems with or questions about this image, please submit a [GitHub issue](https://github.com/makuk66/docker-solr/issues).

## Contributing

If you have have a contribution for this repository, please send a pull request.

If you want to contribute to Solr, see the [Solr Resources](http://lucene.apache.org/solr/resources.html).

# License

Solr is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0), and this repository is too:

Copyright 2015 Martijn Koster

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
