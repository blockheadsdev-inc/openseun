FROM maven:3.8.4-openjdk-17-slim AS build
COPY src /src
COPY pom.xml pom.xml
RUN mvn -f pom.xml clean package -DskipTests

FROM openjdk:17-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} seunswap-v1.jar
EXPOSE 8200
ENTRYPOINT ["java","-jar","/seunswap-v1.jar"]