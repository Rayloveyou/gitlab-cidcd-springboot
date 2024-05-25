# Stage 1: Build stage
FROM maven:3.8.3-openjdk-17 as build
WORKDIR /app
COPY . .

RUN mvn install -DskipTests=true

# Stage 2: Production stage
FROM openjdk:17-jdk-alpine3.14 as production

RUN addgroup --system --gid 1001 fullstack
RUN adduser --system --uid 1001 fullstack

WORKDIR /app
COPY --from=build /app/target/springboot-backend-0.0.1-SNAPSHOT.jar app.jar

RUN chown -R fullstack:fullstack /app
USER fullstack

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
