# puppet-tomcat

Puppet module to install Apache Tomcat and run instances as Runit services
under one or more users.

The recommended usage is to place the configuration in hiera and just:

    include tomcat

Example hiera config:

    tomcat::config:
      bind_address: %{fqdn}

    tomcat::files:
      conf/server.xml:
        mode:     '0440'
        source:   'puppet:///files/tomcat/myapp/server.xml'
      lib/postgresql-9.2-1002.jdbc4.jar:
        source:   'puppet:///files/jdbc/postgresql-9.2-1002.jdbc4.jar'

    tomcat::templates:
      conf/tomcat-users.xml:
        mode:     '0440'
        template: '/var/lib/puppet/files/tomcat/myapp/tomcat-users.xml.erb'
    
    tomcat::group:     'tomcat'
    
    tomcat::java_home: '/usr/java/jdk1.7.0_09'
    
    tomcat::java_opts: '-Xms1536m -Xmx1536m -XX:MaxPermSize=512m'
    
    tomcat::version:   '7.0.32'
    
    tomcat::instances:
      tomcat1:
        basedir:      '/apps/tomcat1'
        logdir:       '/apps/tomcat1/logs'
        config:
          bind_address: %{ipaddress_eth0_1}
      tomcat2:
        basedir:      '/apps/tomcat2'
        logdir:       '/apps/tomcat2/logs'
        config:
          bind_address: %{ipaddress_eth0_2}

## tomcat parameters

*basedir*: The base installation directory. Default: '/opt/tomcat'

*config*: A hash of additional configuration variables that will be set when
templates are processed.

*files*: A hash of configuration files to install - see below

*group*: The user''s primary group. Default: 'tomcat',

*java_home*: The base directory of the JDK installation to be used. Default:
'/usr/java/latest',

*java_opts*: Additional java command-line options to pass to the startup script

*logdir*: The base log directory. Default: '/var/logs/tomcat'

*min_mem*: The minimum heap size allocated by the JVM. Default: 1024m

*max_mem*: The maximum heap size allocated by the JVM. Default: 2048m

*mode*: The permissions to create files with (eg. 0444).

*remove_docs*: Whether or not to remove the Tomcat docs under webapps. Default: true

*remove_examples*: Whether or not to remove the Tomcat examples under webapps. Default: true

*templates*: A hash of configuration templates to process and install - see below

*version*: The version of the product to install (eg. 7.0.37). **Required**.

*workspace*: A temporary directory to unpack install tarballs into. Default:
'/root/tomcat'

## tomcat::instance parameters

*title*: The user the Tomcat instance runs as

Plus all of the parameters specified in 'tomcat parameters' above

## Config files

Files or templates for each of the Tomcat instances can be delivered via
Puppet.  The former are delivered as-is while the latter are processed as ERB
templates before being delivered.

For example configuration could be delivered using for instances running as the
tomcat1 and tomcat2 users with:

    tomcat::config:
      bind_address: %{fqdn}

    tomcat::files:
      conf/tomcat-users.xml:
        source: 'puppet:///files/tomcat/dev/tomcat-users.xml'
      
    tomcat:
      tomcat1:
        templates:
          conf/server.xml:
            template: '/etc/puppet/templates/tomcat/dev1/server.xml.erb'
      tomcat2:
        templates:
          conf/server.xml:
            template: '/etc/puppet/templates/tomcat/dev2/server.xml.erb'

Values set at the tomcat level as set for all instances so both the tomcat1 and
tomcat2 instance would get the same tomcat-users.xml file.  Each instance would
get their own server.xml file based on the template specified with instance
variables (like basedir and logdir) and config variables (like bind_address
above) substituted.

For example:

    <Connector address="<%= @config['bind_address'] %>"
               port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" compression="force"/>

All files and templates are relative to the product installation.  For example
if the product installation is '/opt/tomcat/apache-tomcat-7.0.37' then the full
path to the 'tomcat-users.xml' file would be
'/opt/tomcat/apache-tomcat-7.0.37/conf/tomcat-users.xml'.

Note that the path specified by the 'template' parameter is on the Puppet
master.

## Product files

Place the product zip files (eg. 'apache-tomcat-7.0.32.tar.gz') under a
'tomcat' directory of the 'files' file store.  For example if
/etc/puppet/fileserver.conf has:

    [files]
    path /var/lib/puppet/files

then put the zip files in /var/lib/puppet/files/tomcat.  Any files specified
with the 'files' parameter can also be placed in this directory.

## Support

License: Apache License, Version 2.0

GitHub URL: https://github.com/erwbgy/puppet-tomcat
