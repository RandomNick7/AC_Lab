# Build stage
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy Gradle wrapper first
COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .
COPY settings.gradle.kts .

# Make wrapper executable
RUN chmod +x ./gradlew

# Copy source
COPY src src

# Build jar
RUN ./gradlew bootJar --no-daemon


# Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
