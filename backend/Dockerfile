# Stage 1: Build using Gradle and JDK 17
FROM gradle:8.4-jdk17 AS build
WORKDIR /app
COPY --chown=gradle:gradle . /app

# Run Gradle build (no tests)
RUN gradle build -x test

# Stage 2: Run using lightweight JRE
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the fat JAR built by Spring Boot plugin
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
