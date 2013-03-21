define tomcat::install (
  $basedir,
  $filestore,
  $group,
  $jolokia,
  $jolokia_address,
  $jolokia_port,
  $jolokia_version,
  $user,
  $version,
  $workspace,
) {
  $tarball = "apache-tomcat-${version}.tar.gz"
  $subdir  = "apache-tomcat-${version}"
  if ! defined(Package['tar']) {
    package { 'tar': ensure => installed }
  }
  if ! defined(Package['gzip']) {
    package { 'gzip': ensure => installed }
  }
  # defaults
  File {
    owner => $user,
    group => $group,
  }
  if ! defined(File[$basedir]) {
    file { $basedir: ensure => directory, mode => '0755' }
  }
  if ! defined(File["${workspace}/${tarball}"]) {
    file { "${workspace}/${tarball}":
      ensure  => present,
      mode    => '0444',
      source  => "${filestore}/${tarball}",
      require => File[$workspace],
    }
  }
  exec { "tomcat-unpack-${user}":
    cwd         => $basedir,
    command     => "/bin/tar -zxf '${workspace}/${tarball}'",
    creates     => "${basedir}/${subdir}",
    notify      => Exec["tomcat-fix-ownership-${user}"],
    require     => [ File[$basedir], File["${workspace}/${tarball}"] ],
  }
  if $jolokia {
    file { "${basedir}/${subdir}/jolokia":
      ensure  => directory,
      mode    => '0755'
      require => Exec["tomcat-unpack-${user}"],
    }
    file { "${basedir}/${subdir}/jolokia/jolokia.war":
      ensure  => present,
      mode    => '0444',
      source  => "${filestore}/jolokia-war-${jolokia_version}.war",
      require => File["${basedir}/${subdir}/jolokia"],
    }
  }
  exec { "tomcat-fix-ownership-${user}":
    command     => "/bin/chown -R ${user}:${group} ${basedir}/${subdir}",
    refreshonly => true,
  }
  file { "${basedir}/tomcat":
    ensure  => link,
    target  => $subdir,
    require => File[$basedir],
  }
}
