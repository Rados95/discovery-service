# maven:3.8.6
FROM maven@sha256:3cd540cea2ec98978069ba5b192476111eff75c221c676a654d80d4fafce8822 as discovery-builder
ENV APPDIR /usr/local/app
RUN mkdir $APPDIR
LABEL "author"="rados" \
    "language"="java" \
    "buildtool"="maven"
WORKDIR $APPDIR
COPY . $APPDIR
RUN mvn clean package

# eclipse-temurin:8u345-b01-jre
FROM eclipse-temurin@sha256:123447d83b8a6f17ca1eab76f8bcc31da08783a347f8f93740d01ea7264162bb
LABEL "author"="rados" \
    "language"="java"
ENV APPDIR /usr/local/app
RUN mkdir $APPDIR
WORKDIR $APPDIR
COPY --from=discovery-builder $APPDIR/target/discovery-service.jar $APPDIR
EXPOSE 8761
CMD ["java", "-jar", "discovery-service.jar"]
