# moviedb

Example App for Elasticsearch Series on [Codemy.net](https://www.codemy.net/posts/search/keyword/elasticsearch)

# Setup

First you will need to download the example data dump from here [Data Dump](https://www.dropbox.com/s/reim7b8fviwubn9/moviedb_development.dump?dl=0)

Once you have the dump file run this command to import it into your local database

```shell
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U user -d yourdb moviedb_development.dump
```
