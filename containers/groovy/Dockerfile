FROM webratio/gvm

# Defines environment variables
ENV GROOVY_VERSION 2.4.4

# Installs Groovy
RUN /bin/bash -c "source /root/.gvm/bin/gvm-init.sh && gvm install groovy ${GROOVY_VERSION}"
ENV GROOVY_HOME /root/.gvm/groovy/current
ENV PATH $GROOVY_HOME/bin:$PATH

ENTRYPOINT ["groovy", "-Dgrape.root=/graperoot"]

COPY . /usr/src/app
WORKDIR /usr/src/app
