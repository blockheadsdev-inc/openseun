FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:17-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} seunswap-v1.jar
EXPOSE 8100
ENTRYPOINT ["java","-jar","/seunswap-v1.jar"]