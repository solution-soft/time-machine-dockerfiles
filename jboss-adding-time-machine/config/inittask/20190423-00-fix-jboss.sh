#!/bin/sh

JBOSS_HOME=/opt/jboss/wildfly

# Create JBOSS home if it does not exist
[ -d $JBOSS_HOME ] || mkdir -p $JBOSS_HOME

# Fix permissions for the running environment
chown -R jboss:root $JBOSS_HOME
chmod -R g+w $JBOSS_HOME
