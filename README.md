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
        template: '/etc/puppet/templates/myapp/tomcat-users.xml.erb'
    
    tomcat::group:     'tomcat'
    
    tomcat::java_home: '/usr/java/jdk1.7.0_17'
    
    tomcat::java_opts: '-XX:MaxPermSize=512m'

    tomcat::jolokia_version: '1.1.1'
    
    tomcat::min_mem:   '256m'
    tomcat::max_mem:   '512m'

    tomcat::version:   '7.0.37'
    
    tomcat::instances:
      tomcat1:
        basedir:         '/apps/tomcat1'
        bind_address:    "%{ipaddress_eth0_1}"
        localhost:       '127.0.0.101'
        logdir:          '/apps/tomcat1/logs'
        jolokia:         'true'
        jolokia_address: %{ipaddress_eth0_1}
        jolokia_port:    '8190'
        config:
          admin_user:    'fbloggs'
        dependencies:
          - '/apps/activemq1/service/activemq'
      tomcat2:
        basedir:         '/apps/tomcat2'
        bind_address:    "%{ipaddress_eth0_2}"
        localhost:       '127.0.0.102'
        logdir:          '/apps/tomcat2/logs'
        config:
          admin_user:    'jbloggs'
        templates:
          conf/server.xml:
            mode:     '0440'
            template: '/etc/puppet/templates/myapp/tomcat-server.xml.erb'

## tomcat parameters

*basedir*: The base installation directory. Default: '/opt/tomcat'

*bind_address*: The IP or hostname to bind listen ports to. Default: $fqdn

*check_port*: The port that the instance must be listening on (bound to
bind_address) for it to be considered up. Default: '8080'

*config*: A hash of additional configuration variables that will be set when
templates are processed.

*dependencies*: A list of Runit service directories whose services must be up
before the Tomcat service is started.

*cpu_affinity*: Enable CPU affinity to be set to only run processes on specific
CPU cores - for example '0,1' to only run processes on the first two cores.

*files*: A hash of configuration files to install - see below

*filestore*: The Puppet filestore location where the Tomcat tarball and Jolokia
war file are downloaded from. Default: 'puppet:///files/tomcat'

*gclog_enabled*:  Whether or not Garbage Collector logging is enabled. Default:
'false'

*gclog_numfiles*: The number of garbage collector log files to keep. Default:
'5'

*gclog_filesize*: The maximum size of a garbage collector log file before it is
rotated. Default: '100M'

*group*: The user''s primary group. Default: 'tomcat',

*java_home*: The base directory of the JDK installation to be used. Default:
'/usr/java/latest'

*java_opts*: Additional java command-line options to pass to the startup script

*jolokia*: Whether or not to install the jolokia war file and configure a
separate service to run it. Default: false

*jolokia_address*: The address that the jolokia HTTP service listens on.
Default: 'localhost'

*jolokia_port*: The port that the jolokia HTTP service listens on. Default:
'8190'

*jolokia_version*: The version of the jolokia war file to download and install.
Default: '1.1.1'

*localhost*: The localhost address to bind listen ports to. Default: 'localhost'

*logdir*: The base log directory. Default: '/var/logs/tomcat'

*min_mem*: The minimum heap size allocated by the JVM. Default: 1024m

*max_mem*: The maximum heap size allocated by the JVM. Default: 2048m

*mode*: The permissions to create files with (eg. 0444).

*remove_docs*: Whether or not to remove the Tomcat docs under webapps. Default: true

*remove_examples*: Whether or not to remove the Tomcat examples under webapps. Default: true

*templates*: A hash of configuration templates to process and install - see below

*ulimit_nofile*: The maximum number of open file descriptors the java process
is allowed.  Default is '$(ulimit -H -n)' which sets the value to the hard
limit in /etc/security/limits.conf (or equivalent) for the user.

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

By default the product tar file (eg. 'apache-tomcat-7.0.32.tar.gz') is expected
to be found under a 'tomcat' directory of the 'files' file store.  For example
if /etc/puppet/fileserver.conf has:

    [files]
    path /var/lib/puppet/files

then put the tar file in /var/lib/puppet/files/tomcat.  Any files specified
with the 'files' parameter can also be placed in this directory, as can the
Jolokia war file.

This location can be changed by setting the 'filestore' parameter.

## Monitoring

The jolokia parameters enable JMX statistics to be queried over HTTP - for example:

    $ curl http://localhost:8190/jolokia/read/java.lang:type=Memory/HeapMemoryUsage
    {"timestamp":1363883323,"status":200,"request":{"mbean":"java.lang:type=Memory"
    ," attribute":"HeapMemoryUsage","type":"read"},"value":{"max":1908932608,"commi
    tted":1029046272,"init":1073741824,"used":155889168}}

To limit what what can be accessed a jolokia-access.xml can be included in the
war file.  This is what I do to ensure read-only access:

    $ cd /var/lib/puppet/files/tomcat
    $ wget http://labs.consol.de/maven/repository/org/jolokia/jolokia-war/1.1.1/jolokia-war-1.1.1.war
    $ vim jolokia-access.xml
    <?xml version="1.0" encoding="utf-8"?>
    <restrict>
      <commands>
        <command>read</command>
        <command>list</command>
        <command>version</command>
        <command>search</command>
      </commands>
      <http>
        <method>get</method>
      </http>
    </restrict>
    $ mkdir -p WEB-INF/classes
    $ cp jolokia-access.xml WEB-INF/classes/
    $ zip -u jolokia-war-1.1.1.war WEB-INF/classes/jolokia-access.xml
    $ rm -rf WEB-INF

See http://www.jolokia.org/ for more information.

## Dependencies

It must be possible to check the status (using 'sv stat') of each of the
service directories specified as dependencies.  This is problematic for
services running as different users as the supervise directory and supervise/ok
file are only accessible by the owner. 

One way to resolve this is to add the user to the destination group and modify
the group permissions - for example:

    $ usermod -a -G activemq tomcat1
    $ cd /apps/activemq1/service/activemq
    $ find . -follow -type d -name 'supervise' -exec chmod g+x {} \;
    $ find . -follow -type p -name 'ok' -exec chmod g+w {} \;

Another way is to use ACLs to grant the user the required permissions - for example:

    $ cd /apps/activemq1/service/activemq
    $ find . -follow -type d -name 'supervise' -exec setfacl -m u:tomcat1:x {} \;
    $ find . -follow -type p -name 'ok' -exec setfacl -m u:tomcat1:w {} \; 

## Support

License: Apache License, Version 2.0

GitHub URL: https://github.com/erwbgy/puppet-tomcat
