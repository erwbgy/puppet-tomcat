define tomcat::install (
  $version,
  $user,
  $group,
  $basedir,
  $workspace = '/root/tomcat'
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
  file { 'tomcat-tarball':
    ensure  => present,
    path    => "${workspace}/${tarball}",
    mode    => '0444',
    source  => "puppet:///files/tomcat/${tarball}",
    require => File[$workspace],
  }
  exec { 'tomcat-unpack':
    cwd         => $basedir,
    command     => "/bin/tar -zxf '${workspace}/${tarball}'",
    creates     => "${basedir}/${subdir}",
    notify      => [ Exec['tomcat-fix-ownership'] , Class['tomcat::config'] ],
    require     => [ Exec['tomcat-basedir'], File['tomcat-tarball'] ],
  }
  exec { 'tomcat-fix-ownership':
    command     => "/bin/chown -R ${user}:${group} ${basedir}/${subdir}",
    refreshonly => true,
  }
  file { "${basedir}/tomcat":
    ensure  => link,
    target  => "${basedir}/${subdir}",
    require => Exec['tomcat-basedir'],
  }
}
