# syntax=docker/dockerfile:1.7

FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -B -q -DskipTests package

FROM eclipse-temurin:21-jre

RUN groupadd --system app \
 && useradd --system --gid app --create-home app

WORKDIR /app

COPY --from=build --chown=app:app /workspace/target/*.jar app.jar

USER app

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
