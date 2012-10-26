define tomcat::runtime (
  $version = undef,
  $user    = undef,
  $group   = undef,
  $basedir = '/opt'
) {
  if $version == undef {
    fail('tomcat::runtime version parameter is required')
  }
  if $user == undef {
    fail('tomcat::runtime user parameter is required')
  }
  if $group == undef {
    fail('tomcat::runtime group parameter is required')
  }
  file { "/home/${user}/service/tomcat":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
  }
  file { "/home/${user}/service/tomcat/run":
    ensure  => present,
    mode    => '0555',
    owner   => $user,
    group   => $group,
    content => template('tomcat/run.erb'),
    require => File["/home/${user}/service/tomcat"],
  }
  file { "/home/${user}/service/tomcat/log":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => File["/home/${user}/service/tomcat"],
  }
  file { "/home/${user}/service/tomcat/log/run":
    ensure  => present,
    mode    => '0555',
    owner   => $user,
    group   => $group,
    content => template('tomcat/log_run.erb'),
    require => File["/home/${user}/service/tomcat/log"],
  }
  $subdir  = "apache-tomcat-${version}"
  $confdir = "${basedir}/${subdir}/conf"
  file { "/home/${user}/conf":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => User[$user],
  }
  file { 'default-catalina.policy':
    ensure  => link,
    path    => "/home/${user}/conf/catalina.policy",
    target  => "${confdir}/catalina.policy",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-catalina.properties':
    ensure  => link,
    path    => "/home/${user}/conf/catalina.properties",
    target  => "${confdir}/catalina.properties",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-context.xml':
    ensure  => link,
    path    => "/home/${user}/conf/context.xml",
    target  => "${confdir}/context.xml",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-logging.properties':
    ensure  => link,
    path    => "/home/${user}/conf/logging.properties",
    target  => "${confdir}/logging.properties",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-tomcat-users.xml':
    ensure  => link,
    path    => "/home/${user}/conf/tomcat-users.xml",
    target  => "${confdir}/tomcat-users.xml",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-web.xml':
    ensure  => link,
    path    => "/home/${user}/conf/web.xml",
    target  => "${confdir}/web.xml",
    replace => false,
    require => File["/home/${user}/conf"],
  }
  file { 'default-server.xml':
    ensure  => link,
    path    => "/home/${user}/conf/server.xml",
    target  => "${confdir}/server.xml",
    replace => false,
    require => File["/home/${user}/conf"],
  }
}
