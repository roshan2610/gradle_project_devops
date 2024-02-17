FROM openjdk:11 as base
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build

FROM tomcat:9
WORKDIR webapps 
#will keep our files here in webapps
COPY --from=base /app/build/libs/sampleWeb-0.0.1-SNAPSHOT.war .
#to remove deafult page will remove the file

RUN rm -rf ROOT && mv sampleWeb-0.0.1-SNAPSHOT.war ROOT.war