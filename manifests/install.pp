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
    path    => "${workspace}/tomcat/${tarball}",
    mode    => '0444',
    source  => "puppet:///files/${tarball}",
    require => File["${workspace}/tomcat"],
  }
  exec { 'tomcat-unpack':
    cwd         => $basedir,
    command     => "/bin/tar -zxf '${workspace}/tomcat/${tarball}'",
    require     => File['tomcat-tarball'],
    creates     => "${basedir}/${subdir}",
  }
  file { "${basedir}/tomcat":
    ensure  => link,
    target  => "${basedir}/${subdir}",
  }
}
