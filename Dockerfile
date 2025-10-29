FROM openjdk:8-jdk-alpine

WORKDIR /usr/app

COPY target/java-maven-app-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
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