FROM openjdk:11-jdk

ENV SBT_VERSION=1.4.3

WORKDIR /project_tmp

RUN \
  apt-get update && \
  apt-get -y install curl && \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt

ADD build.sbt .
ADD project/plugins.sbt project/plugins.sbt

RUN sbt update
RUN sbt compile

RUN mkdir /project
VOLUME /project
WORKDIR /project
RUN rm -rf /project_tmp
