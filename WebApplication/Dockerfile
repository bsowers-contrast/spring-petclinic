FROM openjdk:17-jdk-slim


# Copy your application's JAR file into the container
COPY target/spring-petclinic-3.1.0-SNAPSHOT.jar app.jar

# Expose port 8081 from the container
EXPOSE 8080

# The command to run your application (note the port configuration)
ENTRYPOINT ["java", "-jar","/app.jar" ]
