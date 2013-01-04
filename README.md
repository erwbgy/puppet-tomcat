# puppet-tomcat

Puppet module to install Apache Tomcat and run instances as Runit services
under one or more users.

The recommended usage is to place the configuration is hiera and just:

    include tomcat

Example hiera config:

    tomcat:
      tomcat1:
        basedir: /apps
        config_files:
          server.xml:
            source: 'puppet:///files/tomcat/dev/server.xml'
        extra_jars:
          - postgresql-9.2-1002.jdbc4.jar
        group: tomcat
        java_home: /usr/java/jdk1.7.0_07
        version: 7.0.32
      tomcat2:
        basedir: /apps
        config_files:
          server.xml:
            source: 'puppet:///files/tomcat/dev/server.xml'
          tomcat-users.xml:
            source: 'puppet:///files/tomcat/dev2/tomcat-users.xml'
        extra_jars:
          - mysql-connector-java-5.1.21.jar
        group: tomcat
        java_home: /usr/java/jdk1.7.0_07
        version: 7.0.32

## Parameters

All product classes take following parameters:

*title*: The user the Tomcat instance runs as

*basedir*: The parent directory of all user instance directories. Default:
'/home' and files will be created under '/home/$user'

*bind_address*: The IP address listen sockets are bound to. Default: $::fqdn

*config_files*: A hash of configuration files to install - see below

*extra_jars*: Additional jar files to be placed in the lib directory

*group*: The user''s primary group. Default: 'wso2',

*java_home*: The base directory of the JDK installation to be used. Default:
'/usr/java/latest',

*java_opts*: Additional java command-line options to pass to the startup script

*min_mem*: The minimum heap size allocated by the JVM. Default: 1024m

*max_mem*: The maximum heap size allocated by the JVM. Default: 2048m

*version*: The version of the product to install (eg. 7.0.32). **Required**.

*worksapce*: A temporary directory to unpack install tarballs into. Default:
'/root/tomcat'

## Config files

Configuration files for each of the Tomcat instances can be delivered via
Puppet.  

For example a configuration files could be delivered using for instances
running as the tomcat1 and tomcat2 users with:

    tomcat:
      tomcat1:
        version: 7.0.32
        config_files:
          server.xml:
            source: 'puppet:///files/tomcat/dev1/server.xml'
          tomcat-users.xml:
            source: 'puppet:///files/tomcat/dev1/tomcat-users.xml'
      tomcat2:
        version: 7.0.32
        config_files:
          server.xml:
            source: 'puppet:///files/tomcat/dev2/server.xml'
          tomcat-users.xml:
            source: 'puppet:///files/tomcat/dev2/tomcat-users.xml'

## Product files

Place the product zip files (eg. 'apache-tomcat-7.0.32.tar.gz') under a
'tomcat' directory of the 'files' file store.  For example if
/etc/puppet/fileserver.conf has:

    [files]
    path /var/lib/puppet/files

the put the zip files in /var/lib/puppet/files/tomcat.  Any files specified
with the extra_jars or config_files options should also be placed in this
directory.

## Support

License: Apache License, Version 2.0

GitHub URL: https://github.com/erwbgy/puppet-tomcat
