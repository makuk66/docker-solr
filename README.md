# Supported tags and respective `Dockerfile` links

-	[`4.10.4`, `4.10`, `4` (*4.10/Dockerfile*)](https://github.com/makuk66/docker-solr/blob/05ba189924dd98ec1a5ea2c921b5f9ef0f474f6c/4.10/Dockerfile)
-	[`5.3.0`, `5.3`, `5`, `latest` (*5.3/Dockerfile*)](https://github.com/makuk66/docker-solr/blob/master/5.3/Dockerfile)

# What is Solr?
Solr is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more. Solr powers the search and navigation features of many of the world's largest internet sites.

Learn more on [Apache Solr homepage](http://lucene.apache.org/solr/) and in the [Apache Solr Reference Guide](https://www.apache.org/dyn/closer.cgi/lucene/solr/ref-guide/).

> [wikipedia.org/wiki/Apache_Solr](https://en.wikipedia.org/wiki/Apache_Solr)

![Solr Logo](https://raw.githubusercontent.com/makuk66/docker-solr/master/logo.png)

# How to use this Docker image

To run a single Solr server:

    SOLR_CONTAINER=$(docker run -d -p 8983:8983 -t makuk66/docker-solr)

Then with a web browser go to `http://localhost:8983/` to see the Admin Console (adjust the hostname for your docker host).

To use Solr, you need to create a "core", an index for your data. For example:

    docker exec -it --user=solr $SOLR_CONTAINER bin/solr create_core -c gettingstarted

In the web UI if you click on "Core Admin" you should now see the "gettingstarted" core.

If you want to load some example data:

    docker exec -it --user=solr $SOLR_CONTAINER bin/post -c gettingstarted example/films/films.json

In the UI, find the "Core selector" popup menu and select the "gettingstarted" core, then select the "Query"
menu item. This gives you a default search for "*:*" which returns all docs. Hit the "Execute Query" button,
and you should see a few docs with film data. Congratulations!

To learn more about Solr, see the [Apache Solr Reference Guide](https://cwiki.apache.org/confluence/display/solr/Apache+Solr+Reference+Guide).

## Single-container SolrCloud

To simulate a distributed Solr configuration ("SolrCloud" mode) on a single container with 2 nodes in separate JVMs, run the "cloud" example:

    docker run -d -p 8983:8983 -p 7574:7574 makuk66/docker-solr \
        /bin/bash -c "/opt/solr/bin/solr -e cloud -noprompt; while true ; do sleep 3600; done"

This will take a minute or so to start. You can follow along with `docker logs -f CONTAINER`.

## Distributed Solr

You can also run a distributed Solr configuration, with Solr nodes in separate containers, sharing a single ZooKeeper server:

Run ZooKeeper, and define a name so we can link to it:

    docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

Run two Solr nodes, linked to the zookeeper container:

    docker run --name solr1 --link zookeeper:ZK -d -p 8983:8983 \
      makuk66/docker-solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

    docker run --name solr2 --link zookeeper:ZK -d -p 8984:8983 \
      makuk66/docker-solr \
      bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

Create a collection:

    docker exec -i -t solr1 /opt/solr/bin/solr create_collection \
        -c collection1 -shards 2 -p 8983

Then go to `http://localhost:8983/solr/#/~cloud` (adjust the hostname for your docker host) to see the two shards and Solr nodes.

# About this repository

This repository is available on [github.com/makuk66/docker-solr](https://github.com/makuk66/docker-solr), and the automated build is on the [Docker Registry](https://registry.hub.docker.com/u/makuk66/docker-solr/).

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
