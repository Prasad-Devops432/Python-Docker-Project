FROM tomcat:9-jdk11-temurin

LABEL maintainer="Prasad-Devops432"

EXPOSE 8080

# The WAR is produced by "mvn clean package" (see pom.xml, finalName = maven-web-app)
COPY target/maven-web-app.war /usr/local/tomcat/webapps/ROOT.war
