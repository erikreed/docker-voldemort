FROM java:7
MAINTAINER erikreed

RUN apt-get update && apt-get install -y wget unzip

ENV VOLDEMORT_VERSION=release-1.9.17-cutoff
RUN wget https://github.com/voldemort/voldemort/archive/$VOLDEMORT_VERSION.zip
RUN unzip $VOLDEMORT_VERSION.zip && mv voldemort-* voldemort

WORKDIR /voldemort/

ENV VOLDEMORT_HOME=/voldemort
RUN ./gradlew clean jar
RUN cp -r config/single_node_cluster config/docker_node
RUN sed -i 's/localhost/voldemort/' config/docker_node/config/cluster.xml

EXPOSE 6666 6667 8081
VOLUME /voldemort/data

CMD ./bin/voldemort-server.sh config/docker_node

