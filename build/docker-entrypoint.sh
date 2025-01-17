#!/bin/sh
#
# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

test ! -f /opt/opentsdb/opentsdb.conf && echo "Missing opentsdb.conf" && exit 1
PROJECTID=$(grep google.bigtable.project.id /opt/opentsdb/opentsdb.conf | awk '{print $3}')
INSTANCEID=$(grep google.bigtable.instance.id /opt/opentsdb/opentsdb.conf | awk '{print $3}')

# custom parameter
PROJECT_ID=${PROJECT_ID}
INSTANCE_ID=${INSTANCE_ID}
ZONE_ID=${ZONE_ID}
KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT}
CONSUMER_NAME=${CONSUMER_NAME}
SYNC_TOPIC=${SYNC_TOPIC}

sed -i "s/PROJECT_ID/$PROJECT_ID/;s/INSTANCE_ID/$INSTANCE_ID/;s/ZONE_ID/$ZONE_ID/;s/KAFKA_ZOOKEEPER_CONNECT/$KAFKA_ZOOKEEPER_CONNECT/;s/CONSUMER_NAME/$CONSUMER_NAME/;s/SYNC_TOPIC/$SYNC_TOPIC/" /opt/opentsdb/opentsdb.conf


export HBASE_HOME=/hbase-1.2.1
export PATH=$PATH:$HBASE_HOME/bin
export OPENTSDB=/opentsdb

sed -i "s/INSTANCEID/$INSTANCEID/;s/PROJECTID/$PROJECTID/" $HBASE_HOME/conf/hbase-site.xml

init() {
    env COMPRESSION=NONE $OPENTSDB/src/create_table.sh
}

start() {
    $OPENTSDB/build/tsdb tsd
}

clean() {
    hbase shell <<EOF
      for table in ["tsdb", "tsdb-meta", "tsdb-tree", "tsdb-uid"]
        disable table
        drop table
      end
EOF
}

case ${1} in
  init)
    init
    ;;
  start)
    start 
    ;;
  clean)
    clean
    ;;
  *)
    exec "$@"
    ;;
esac

