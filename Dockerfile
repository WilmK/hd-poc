# Stage 1: 빌드 단계 (Maven 설치 없이 Maven Wrapper 사용)
FROM openjdk:17 AS builder
WORKDIR /app

# 전체 프로젝트 파일 복사 (mvnw, .mvn 폴더, pom.xml, src 등 모두 포함되어야 함)
COPY . .

# mvnw 실행 권한 부여
RUN chmod +x mvnw

# Maven Wrapper를 사용하여 애플리케이션 빌드 (필요시 -DskipTests 옵션 사용)
RUN ./mvnw clean package -DskipTests

# Stage 2: 실행 단계
FROM openjdk:17-jdk-slim
WORKDIR /app

# 빌드 단계에서 생성된 jar 파일 복사 (jar 파일 이름은 프로젝트에 따라 달라질 수 있음)
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
