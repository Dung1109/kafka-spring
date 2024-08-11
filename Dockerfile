## syntax=docker/dockerfile:1
#
## Comments are provided throughout this file to help you get started.
## If you need more help, visit the Dockerfile reference guide at
## https://docs.docker.com/go/dockerfile-reference/
#
## Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7
#
#################################################################################
#
## Create a stage for resolving and downloading dependencies.
#FROM eclipse-temurin:21-jdk-jammy as deps
#
#WORKDIR /build
#
## Copy the gradlew wrapper with executable permissions.
#COPY --chmod=0755 gradlew gradlew
#COPY gradle/ gradle/
#
## Download dependencies as a separate step to take advantage of Docker's caching.
## Leverage a cache mount to /root/.gradle so that subsequent builds don't have to
## re-download packages.
#COPY build.gradle settings.gradle ./
#RUN --mount=type=cache,target=/root/.gradle ./gradlew build --no-daemon -x test
#
#################################################################################
#
## Create a stage for building the application based on the stage with downloaded dependencies.
## This Dockerfile is optimized for Java applications that output a fat/uber jar, which includes
## all the dependencies needed to run your app inside a JVM. If your app doesn't output a fat jar
## and instead relies on an application server like Apache Tomcat, you'll need to update this
## stage with the correct filename of your package and update the base image of the "final" stage
## use the relevant app server, e.g., using tomcat (https://hub.docker.com/_/tomcat/) as a base image.
#FROM deps as package
#
#WORKDIR /build
#
#COPY src/ src/
#RUN --mount=type=cache,target=/root/.gradle ./gradlew build  --no-daemon -x test && \
#    cp build/libs/*.jar app.jar
#
#################################################################################
#
## Create a new stage for running the application that contains the minimal
## runtime dependencies for the application. This often uses a different base
## image from the install or build stage where the necessary files are copied
## from the install stage.
##
## The example below uses eclipse-temurin's JRE image as the foundation for running the app.
## By specifying the "21-jre-jammy" tag, it will also use whatever happens to be the
## most recent version of that tag when you build your Dockerfile.
## If reproducibility is important, consider using a specific digest SHA, like
## eclipse-temurin@sha256:99cede493dfd88720b610eb8077c8688d3cca50003d76d1d539b0efc8cca72b4.
#FROM eclipse-temurin:21-jre-jammy AS final
#
## Create a non-privileged user that the app will run under.
## See https://docs.docker.com/go/dockerfile-user-best-practices/
##ARG UID=10001
##RUN adduser \
##    --disabled-password \
##    --gecos "" \
##    --home "/nonexistent" \
##    --shell "/sbin/nologin" \
##    --no-create-home \
##    --uid "${UID}" \
##    appuser
##USER appuser
#
## Copy the executable from the "package" stage.
#COPY --from=package /build/app.jar app.jar
#
#EXPOSE 8080
#
#ENTRYPOINT [ "java", "-jar", "app.jar" ]


FROM bellsoft/liberica-runtime-container:jdk-21-slim-musl
COPY build/libs/demo-kafka-tracking-service-0.0.1-SNAPSHOT.jar /opt/app/app.jar
WORKDIR /opt/app
EXPOSE 8080
CMD ["java", "-showversion", "-jar", "app.jar"]

#FROM alpine:latest AS build
#ENV JAVA_HOME /opt/jdk/jdk-21.0.1+12
#ENV PATH $JAVA_HOME/bin:$PATH
#
#ADD https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-jdk_x64_alpine-linux_hotspot_21.0.1_12.tar.gz /opt/jdk/
#RUN tar -xzvf /opt/jdk/OpenJDK21U-jdk_x64_alpine-linux_hotspot_21.0.1_12.tar.gz -C /opt/jdk/
#RUN ["jlink", "--compress=2", \
#     "--module-path", "/opt/jdk/jdk-21.0.1+12/jmods/", \
#     "--add-modules", "java.base,java.logging,java.naming,java.desktop,jdk.unsupported", \
#     "--no-header-files", "--no-man-pages", \
#     "--output", "/springboot-runtime"]
#
#FROM alpine:latest
#COPY --from=build  /springboot-runtime /opt/jdk
#ENV PATH=$PATH:/opt/jdk/bin
#EXPOSE 8080
#COPY ./build/libs/demo-kafka-tracking-service-0.0.1-SNAPSHOT.jar /opt/app/app.jar
#WORKDIR /opt/app
#CMD ["java", "-showversion", "-jar", "app.jar"]
