# cassandra-discogs-import
Import Discogs XML database dump into Cassandra

## Migrate schemas 

```
make migrae
```

## Import datasets

```
perl migrate.pl $DATASET <column-name>
```
