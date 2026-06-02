FROM tomcat:9-jdk11-temurin
MAINTAINER krishna 
EXPOSE 8080
COPY target/maven-web-app.war /usr/local/tomcat/webapps/ROOT.war
