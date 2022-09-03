FROM maven:latest as discovery-builder
ENV APPDIR /usr/local/app
RUN mkdir $APPDIR
LABEL "author"="rados" \
    "language"="java" \
    "buildtool"="maven"
WORKDIR $APPDIR
COPY . $APPDIR
RUN mvn clean package

FROM openjdk:latest
LABEL "author"="rados" \
    "language"="java"
ENV APPDIR /usr/local/app
RUN mkdir $APPDIR
WORKDIR $APPDIR
COPY --from=builder $APPDIR/target/discovery-service.jar $APPDIR
EXPOSE 8761
CMD ["java", "-jar", "discovery-service.jar"]
