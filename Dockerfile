#
# Copyright 2014-2015 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hawkular-Metrics DockerFile
#
# This dockerfile can be used to create a Hawkular-Metrics docker
# image to be run on Openshift.

FROM jboss/wildfly:10.1.0.Final

# The image is maintained by the Hawkular Metrics team
MAINTAINER Hawkular Metrics <hawkular-dev@lists.jboss.org>

#
ENV HAWKULAR_METRICS_ENDPOINT_PORT="8080" \
    CASSANDRA_NODES="hawkular-cassandra" \
    HAWKULAR_METRICS_VERSION="0.28.2.Final" \
    HAWKULAR_METRICS_DIRECTORY="/opt/hawkular" \
    HAWKULAR_METRICS_SCRIPT_DIRECTORY="/opt/hawkular/scripts/" \
    PATH=$PATH:$HAWKULAR_METRICS_SCRIPT_DIRECTORY \
    ADMIN_TOKEN="secret" \
    JAVA_OPTS_APPEND="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdump"

# The http and https ports
EXPOSE 8080

# Get and copy the hawkular metrics war to the deployment directory
RUN cd $JBOSS_HOME/standalone/deployments/ && \
    curl -Lo hawkular-metrics.ear http://origin-repository.jboss.org/nexus/content/repositories/public/org/hawkular/metrics/hawkular-metrics-standalone-dist/${HAWKULAR_METRICS_VERSION}/hawkular-metrics-standalone-dist-${HAWKULAR_METRICS_VERSION}.ear

#COPY standalone.conf \
#     $JBOSS_HOME/bin/

#COPY hawkular-metrics-wrapper.sh \
#     $HAWKULAR_METRICS_SCRIPT_DIRECTORY


# Overwrite the default Standalone.xml file with one that activates the HTTPS endpoint
COPY standalone.xml $JBOSS_HOME/standalone/configuration/standalone.xml

COPY entrypoint.sh $HAWKULAR_METRICS_SCRIPT_DIRECTORY

USER root

RUN chmod -R 777 /opt

USER 1000


CMD $HAWKULAR_METRICS_SCRIPT_DIRECTORY/entrypoint.sh


#Overwrite the default logging.properties file
#COPY logging.properties $JBOSS_HOME/standalone/configuration/logging.properties
