#!/bin/bash
exec 2>&1 /opt/jboss/wildfly/bin/standalone.sh  -b `hostname -i`  -bprivate `hostname -i` -b 0.0.0.0 -Dhawkular-metrics.cassandra-nodes=hawkular-cassandra
