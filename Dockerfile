FROM maven:3.9.2-eclipse-temurin-11-alpine as builder
COPY . /tmp/
WORKDIR /tmp/
RUN mvn -B package -DskipTests

FROM apache/nifi:1.21.0
COPY --from=builder /tmp/nifi-web-ui/target/nifi-web-ui-1.20.0.war NAR-INF/bundled-dependencies/nifi-web-ui-1.20.0.war
USER root
RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get install zip && \
     apt-get -y autoremove && \
     apt-get clean
RUN zip -rum lib/nifi-server-nar-1.20.0.nar NAR-INF/ && \
    rm -rf NAR-INF
USER nifi

