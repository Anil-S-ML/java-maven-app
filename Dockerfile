FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /build
COPY pom.xml .
COPY src/ src/
RUN apt-get update && apt-get install -y maven && mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy
WORKDIR /usr/app
COPY --from=build /build/target/java-maven-app-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
