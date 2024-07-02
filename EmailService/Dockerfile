FROM adoptopenjdk/openjdk8

# Copy your application's JAR file into the container
COPY target/EmailService-2.7.18.jar app.jar
RUN apt-get update && apt-get --assume-yes install socat
# Expose port 8081 from the container
EXPOSE 8081

# The command to run your application (note the port configuration)
ENTRYPOINT ["java","-Dcom.sun.jndi.ldap.object.trustURLCodebase=true","-jar","/app.jar" ]
