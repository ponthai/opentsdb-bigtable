# opentsdb-bigtable for opentsdb-rpc-kafka
Docker image that builds OpenTSDB using Bigtable with latest asyncbigtable. It uses for integrating with opentsdb-rpc-kafka to sync the metric from Kafka into OpenTSDB.

## Build the image
```
$ docker build -t opentsdb-bigtable-rpc-kafka .
```

## Run the image
```
$ docker run -dit \
-p 4242:4242 \
-e PROJECT_ID=${PROJECT_ID} \
-e INSTANCE_ID=${INSTANCE_ID} \
-e ZONE_ID=${ZONE_ID} \
-e KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT} \
-e CONSUMER_NAME=${CONSUMER_NAME} \
-e SYNC_TOPIC=${SYNC_TOPIC} \
 opentsdb-bigtable-rpc-kafka
```
