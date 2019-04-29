# Extending Time Machine Docker Image #

With the release of docker images for Time Machine from SolutionSoft Systems, Inc., customers can easily 

1. add applications to create new production images; or
2. integrate time machine into their existing application images

so that they can leverage the virtual clocks provided by Time Machine to facilitate time shift testings on the application.

This white paper will describe two approaches to enable virtual clocks for *Wildfly/JBoss* application. The first approach will add *Wildfly/JBOSS* application into the published *Time Machine* image.  The second approach will add *Time Machine* capability into the official *Wildfly/JBoss* image.

Before we proceed with the approaches in details, we want to describe the mechanism for running *Time Machine* and other applications.

## Mechanism for Running Time Machine ##

A *Time Machine* installation will have the following three components:

1. Commands to interact with the host *Time Machine* server to define the virtual clocks;
2. An agent daemon enables *Time Machine Console* to remotely define the virtual clocks in the container;
3. A license daemon which reserves license from the license server and release the license when the container will be stopped.

We have provided an `/entrypoint.sh` script to properly start all *Time Machine* components.  There are primarily two steps:

1. When the container first starts, the script `/entrypoint.sh` will check for init scripts under directory `/inittasks` and run them one by one.  Once they are run, directory `/inittasks` will be removed to prevent any possible duplicate init tasks.
	
	Examples of the init tasks can be creating directories, change permissions.  one of the init task is to generate floating license token.
	
2. A `supervisord` suepr daemon is invoked to manage daemons such as *Time Machine Agent* and *Time Machine License Daemon*.

## Extending Time Machine Image with Wildfly/JBoss ##

We took the following steps to add *Wildfly/Jboss* to the Time Machine docker image:

1. Create a *jboss* user and group to launch the *Jboss* application;
2. Install *JDK* and *wildfly/jboss* code into the image;
3. Add script to fix *JBoss* home directory permission; and
4. Add service script to start *wildfly/jboss* managed by *supervisord* super daemon

The first two tasks are handled in the `Dockerfile` as RUN commands.  The last two are implemented as (1) inittask script; and (2) supervisord service script.  You can find these scripts under the `config/` directory.

For details, please refer to github repo at: 
`https://github.com/solution-soft/time-machine-dockerfiles/tree/master/time-machine-adding-jboss`

## Adding Time Machine to Wildfly/JBoss Image ##

We took the following steps to add *Time Machine* into the official *Wildfly/JBoss* image.

1. Install `python3.6` and `supervisord` packages.  For *Centos7*, we need to eanble *Software Collections Repository*;
2. Grab and install *Time Machine* from URL: `ftp://ftp.solution-soft.com/pub/tm/linux/redhat/64bit`.  The latest *Time Machine* release is *V12.9R3*;
3. Copy files under `/config` to directory `/` in docker.  

	Files are: 
	
	* start up scripts `/entrypoint.sh`, 
	* init tasks under `/inittask`; 
	* *Time Machine license daemon* under `/usr/local/bin` and 
	* *supervisord* service script for (1) *Time Machine Agent*; (2) *Time Machine License Daemon* and (3) *Wildfly/JBoss*.

For dertails, please refer to github repo at: `https://github.com/solution-soft/time-machine-dockerfiles/tree/master/jboss-adding-time-machine`