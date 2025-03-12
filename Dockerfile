# Step 1: Use a base image that has Java 17
FROM openjdk:jdk-17 AS build

# Step 2: Install Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /app
# Step 4: Copy the pom.xml and download dependencies (optional, but speeds up build)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Step 5: Copy the entire project and build it
COPY . .
RUN mvn clean package -DskipTests

# Step 6: Use a lightweight image to run the application
FROM openjdk:jdk-17

# Step 7: Set the working directory inside the container
WORKDIR /app

# Step 8: Copy the jar file from the build image to the final image
COPY --from=build /app/target/*.jar app.jar