FROM solutionsoft/time-machine-for-centos7:latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

# User root user to install software
USER root

# ----------------------------------------------------------------------------------
# Construct base --
#  This section is lifed from jboss-dockerfiles/base
#  See https://github.com/jboss-dockerfiles/base/blob/master/Dockerfile

# Install packages necessary to run EAP
RUN yum update -y \
&&  yum -y install xmlstarlet saxon augeas bsdtar unzip \
&&  yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 \
&&  useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss \
&&  chmod 755 /opt/jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# --------------------------------------------------------------------------------
# Install JDK for jboss --
#  This section is lifed from jboss-dockerfiles/base-jdk
#  See https://github.com/jboss-dockerfiles/base-jdk/blob/jdk8/Dockerfile

# Install necessary packages
RUN yum -y install java-1.8.0-openjdk-devel \
&&  yum clean all

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/java

# -------------------------------------------------------------------------------
# Install wildfly --
#  This section is lifted from jboss-dockerfiles/wildfly
#  See https://github.com/jboss-dockerfiles/wildfly/blob/master/Dockerfile

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 16.0.0.Final
ENV WILDFLY_SHA1 287c21b069ec6ecd80472afec01384093ed8eb7d
ENV JBOSS_HOME /opt/jboss/wildfly

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

COPY config /

# Expose the ports we're interested in
EXPOSE 8080
