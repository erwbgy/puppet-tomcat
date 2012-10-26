class tomcat::install (
  $version   = undef,
  $user      = undef,
  $group     = undef,
  $basedir   = undef,
  $workspace = undef
) {
  if $version == undef {
    fail('tomcat::install version parameter required')
  }
  if $user == undef {
    fail('tomcat::install user parameter required')
  }
  if $group == undef {
    fail('tomcat::install group parameter required')
  }
  $tarball = "apache-tomcat-${version}.tar.gz"
  $subdir  = "apache-tomcat-${version}"
  package { ['tar', 'gzip']:
    ensure => installed,
  }
  # defaults
  File {
    owner => $user,
    group => $group,
  }
  file { 'tomcat-tarball':
    ensure  => present,
    path    => "${workspace}/${tarball}",
    mode    => '0444',
    source  => "puppet:///files/${tarball}",
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
