#Base Image node:12.18.4-alpine
FROM node:12.18.4-alpine

#Set working directory to /app
WORKDIR /app

#Set PATH /app/node_modules/.bin
ENV PATH /app/node_modules/.bin:$PATH

#Copy package.json in the image
COPY package.json ./

#Run npm install command
RUN npm install

#Copy the app
COPY . ./

EXPOSE 3000

#Start the app
CMD ["node", "./src/server.js"]

#########Jave App#####################################################
FROM openjdk:11-jdk-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY target/my-web-app.war /app/my-web-app.war

# Expose port
EXPOSE 8080

# Run application
CMD ["java", "-jar", "/app/my-web-app.war"]

#################################Java Application##################################

FROM openjdk:11
LABEL maintainer="Nav <youremail@example.com>"

# Download and install Tomcat
ENV TOMCAT_MAJOR_VERSION=10 \
    TOMCAT_MINOR_VERSION=10.0.14 \
    CATALINA_HOME=/opt/tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_MINOR_VERSION/bin/apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz && \
    tar -xzf apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz && \
    rm apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz && \
    mv apache-tomcat-$TOMCAT_MINOR_VERSION $CATALINA_HOME

# Add configuration files
COPY conf/* $CATALINA_HOME/conf/

# Set environment variables
ENV PATH $PATH:$CATALINA_HOME/bin
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Djavax.servlet.request.encoding=UTF-8 -Djavax.servlet.response.encoding=UTF-8"

# Expose HTTP port
EXPOSE 8082

# Start Tomcat
CMD ["catalina.sh", "run"]