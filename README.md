# puppet-tomcat

Puppet module to install Apache Tomcat and run instances as Runit services
under one or more users.

The recommended usage is to place the configuration in hiera and just:

    include tomcat

Example hiera config:

    tomcat::config:
      admin_user: 'admin'
    
    tomcat::cpu_affinity: '0,1'
    
    tomcat::files:
      lib/postgresql-9.2-1002.jdbc4.jar:
        source:   'puppet:///files/jdbc/postgresql-9.2-1002.jdbc4.jar'
    
    tomcat::templates:
      conf/tomcat-users.xml:
        mode:     '0440'
        template: '/var/lib/puppet/files/tomcat/myapp/tomcat-users.xml.erb'
    
    tomcat::group:     'tomcat'
    
    tomcat::java_home: '/usr/java/jdk1.7.0_09'
    
    tomcat::java_opts: '-Xms1536m -Xmx1536m -XX:MaxPermSize=512m'
    
    tomcat::version:   '7.0.37'
    
    tomcat::instances:
      tomcat1:
        basedir:      '/apps/tomcat1'
        bind_address: %{ipaddress_eth0_1}
        logdir:       '/apps/tomcat1/logs'
        config:
          admin_user: 'fbloggs'
      tomcat2:
        basedir:      '/apps/tomcat2'
        bind_address: %{ipaddress_eth0_2}
        logdir:       '/apps/tomcat2/logs'
        config:
          admin_user: 'jbloggs'

## tomcat parameters

*basedir*: The base installation directory. Default: '/opt/tomcat'

*bind_address*: The IP or hostname to bind listen ports to. Default: $fqdn

*check_port*: The port that the instance must be listening on (bound to
bind_address) for it to be considered up. Default: '8080'

*config*: A hash of additional configuration variables that will be set when
templates are processed.

*cpu_affinity*: Enable CPU affinity to be set to only run processes on specific
CPU cores - for example '0,1' to only run processes on the first two cores.

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
      admin_user: 'admin'
      admin_pass: 'admin'

    tomcat::files:
      conf/tomcat-users.xml:
        source: 'puppet:///files/tomcat/dev/context.xml'
      
    tomcat:
      tomcat1:
        config:
          admin_pass: 'tinstaafl'
        templates:
          conf/tomcat-users.xml:
            template: '/etc/puppet/templates/tomcat/dev1/tomcat-users.xml.erb'
      tomcat2:
        config:
          admin_pass: 'timtowtdi'
        templates:
          conf/tomcat-users.xml:
            template: '/etc/puppet/templates/tomcat/dev2/tomcat-users.xml.erb'

Values set at the tomcat level as set for all instances so both the tomcat1 and
tomcat2 instance would get the same context.xml file.  Each instance would get
their own tomcat-users.xml file based on the template specified with instance
variables (like basedir and logdir) and config variables (like admin_user and
admin_pass above) substituted.

For example:

    <user username="<%= @admin_user %>"
          password="<%= @admin_pass %>"
          roles="tomcat,manager-gui"/>

All files and templates are relative to the product installation.  For example
if the product installation is '/opt/tomcat/apache-tomcat-7.0.37' then the full
path to the 'tomcat-users.xml' file would be
'/opt/tomcat/apache-tomcat-7.0.37/conf/tomcat-users.xml'.

Note that the path specified by the 'template' parameter is on the Puppet
master.

## Default templates

There are default templates for conf/server.xml to listen on the specified
bind_address and for conf/logging.properties to use the specified logdir.
These defaults are only used if the template is not specified using the
templates configuration.

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
