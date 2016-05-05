# moviedb

Example App for Elasticsearch Series on [Codemy.net](https://www.codemy.net/posts/search/keyword/elasticsearch)

## Dependencies

+ PostgreSQL 9.3+
+ Elasticsearch 1.7+
+ Redis 2.8+

## Setup

Copy `database.yml.example` as `database.yml` then run

```shell
rake db:create db:schema:load
```

You will need to download the example data dump from here [Data Dump](https://www.dropbox.com/s/reim7b8fviwubn9/moviedb_development.dump?dl=0)

Once you have the dump file run this command to import it into your local database

```shell
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U user -d yourdb moviedb_development.dump
```

Once you have the data in your database you will need to index it into your elasticsearch

```shell
rails c
```

Once you are in the console use this, snippet of code. It will queue all the movies in the database for indexing.

```ruby
Movie.find_each do |m|
  m.index_document
end
```

Start your sidekiq process so it runs the actual indexing

```shell
bundle exec sidekiq -q elasticsearch
```