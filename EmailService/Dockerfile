FROM adoptopenjdk/maven-openjdk8 AS builder

ADD EmailService/pom.xml /emailservice-src/pom.xml
ADD EmailService/src /emailservice-src/src
ADD EmailService/mvnw /emailservice-src/mvnw
ADD ./contrast_security.yaml /emailservice-src/contrast_security.yaml

WORKDIR /emailservice-src

RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests=true


FROM adoptopenjdk/openjdk8

RUN mkdir -p /etc/contrast/java/


COPY --from=builder /emailservice-src/target/EmailService-1.0.0-SNAPSHOT.jar /app.jar
COPY --from=builder /emailservice-src/contrast_security.yaml /etc/contrast/java/contrast_security.yaml


# Install socat, used for reverse shell
RUN apt-get update && apt-get --assume-yes install socat
RUN curl -Ls "https://download.java.contrastsecurity.com/latest/" -o /contrast.jar

# Expose port 8081 from the container
EXPOSE 8081

ENTRYPOINT ["java","-javaagent:/contrast.jar","-Dcom.sun.jndi.ldap.object.trustURLCodebase=true","-jar","/app.jar" ]









