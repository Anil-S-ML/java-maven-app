FROM openjdk:17-slim

# Set working directory inside the container
WORKDIR /usr/app

# Copy the built JAR file from target folder
COPY target/java-maven-app-*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
# Use Java 17 instead of 8
# FROM openjdk:17-jdk-slim

# WORKDIR /usr/app
# COPY target/java-maven-app-*.jar app.jar

# EXPOSE 8080
# ENTRYPOINT ["java", "-jar", "app.jar"]

# Use JDK 17
# FROM openjdk:17-jdk-slim

# WORKDIR /usr/app
# COPY target/java-maven-app-*.jar app.jar

# EXPOSE 8080
# ENTRYPOINT ["java", "-jar", "app.jar"]

# FROM openjdk:8-jdk-alpine

# WORKDIR /usr/app

# COPY target/java-maven-app-*.jar app.jar

# EXPOSE 8080

# ENTRYPOINT ["java", "-jar", "app.jar"]
# FROM openjdk:8-jdk-alpine

# WORKDIR /usr/app
# COPY target/java-maven-app-1.1.0-SNAPSHOT.jar app.jar

# EXPOSE 8080
# ENTRYPOINT ["java", "-jar", "app.jar"]
# FROM openjdk:8-jdk-alpine

# EXPOSE 8080


# COPY ./target/java-maven-app*.jar /usr/app/
# WORKDIR /usr/app

# ENTRYPOINT ["java", "-jar", "java-maven-app*.jar"]