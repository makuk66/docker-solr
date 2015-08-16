
Docker Solr FAQ
===============


How do I persist Solr data?
---------------------------

Your data is persisted already, in your container's filesystem.
If you `docker run`, add data to Solr, then `docker stop` and later
`docker start`, then your data is still there.

Equally, if you `docker commit` your container, you can later create a new
container from that image, and that will have your data in it.

But usually when people ask this question, what they are after is a way
to store Solr data in a separate [Docker Volume|https://docs.docker.com/userguide/dockervolumes/], so that they
can inspect the data in the Docker host when the container is not running,
and later easily run new containers against that data. This is indeed
possible, but there are a few gotchas.

Solr stores its core data in the `server/solr` directory, in sub-directories
for each core. The `server/solr` directory also contains configuration files
that are part of the Solr distribution.
Now, if we mounted volumes for each core individually, then that would
interfere with Solr trying to create those directories. If instead we make
the whole directory a volume, then we need to provide those configuration files
in our volume. For example:

```
# create a directory to store the server/solr directory
$ mkdir /mnt/data1/docker-volumes/maksolr1

# make sure its host owner matches the container's solr user
$ sudo chown 999:999 /mnt/data1/docker-volumes/maksolr1

# copy the solr directory from a temporary container to the volume
$ docker run -it --rm -v /mnt/data1/docker-volumes/maksolr1:/target makuk66/docker-solr cp -r server/solr /target/

# pass the solr directory to a new container running solr
$ SOLR_CONTAINER=$(docker run -d -P -v /mnt/data1/docker-volumes/maksolr1/solr:/opt/solr/server/solr makuk66/docker-solr)

# create a new collection
$ docker exec -it --user=solr $SOLR_CONTAINER bin/solr create_core -c gettingstarted

# check the volume on the host:
$ ls /mnt/data1/docker-volumes/maksolr1/solr/
configsets  gettingstarted  README.txt  solr.xml  zoo.cfg
```


How do I modify Solr config files?
----------------------------------

See the previous question.
