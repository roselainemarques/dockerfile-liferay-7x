FROM openjdk:8
LABEL maintainer="Roselaine <roselaine.nickoly@gmail.com>"

WORKDIR /usr/local


ENV LIFERAY_HOME=/usr/local/liferay-commerce-2.0.0
ENV CATALINA_HOME=$LIFERAY_HOME/tomcat-9.0.17
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV LIFERAY_TOMCAT_URL=https://cdn.lfrs.sl/releases.liferay.com/commerce/2.0.0/liferay-commerce-2.0.0-201906242249.7z

RUN apt-get -qq update && \
	apt-get -qq install telnet && \
	apt-get -qq install p7zip-full && \
	apt-get -qq clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	useradd -ms /bin/bash liferay && \
	set -x && \
  	mkdir -p $LIFERAY_HOME && \
	curl -fSL "$LIFERAY_TOMCAT_URL" -o liferay-commerce-2.0.0-201906242249 && \
	7za x liferay-commerce-2.0.0-201906242249 && \
	rm liferay-commerce-2.0.0-201906242249 && \
	rm -rf $CATALINA_HOME/work/* && \
	chmod 744 $CATALINA_HOME/bin/*.sh && \
	mkdir -p $LIFERAY_HOME/data/document_library && \
	mkdir -p $LIFERAY_HOME/data/elasticsearch/indices

#COPY . /configs/setenv.sh . /usr/local/liferay-commerce-2.0.0-201906242249/bin/setenv.sh

RUN chown -R liferay:liferay $LIFERAY_HOME

USER liferay

EXPOSE 8080/tcp

ENTRYPOINT ["catalina.sh", "run"]