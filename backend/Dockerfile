# Dockerfile for Spring Boot backend
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY . /app
RUN mvn -B package --file pom.xml -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
