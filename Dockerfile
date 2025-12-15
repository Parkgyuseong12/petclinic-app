FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests && \
    ls -la target/ && \
    mv target/*.jar target/app.jar

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=petclinic
ENV DB_USERNAME=petclinic
ENV DB_PASSWORD=petclinic

EXPOSE 8080

ENTRYPOINT ["java", "-Dspring.profiles.active=mysql", "-jar", "app.jar"]
