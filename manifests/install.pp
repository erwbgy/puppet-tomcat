class tomcat::install {
  $workdir = $tomcat::workdir
  $version = $tomcat::version
  $tarball = "apache-tomcat-${version}.tar.gz"
  $subdir  = "apache-tomcat-${version}"
  # Assume we have a tarball
  realize( Package['tar', 'gzip'] )
  # defaults
  File {
    owner => $tomcat::user,
    group => $tomcat::group,
  }
  file { 'tomcat-tarball':
    ensure  => present,
    path    => "${workdir}/${tarball}",
    mode    => '0444',
    source  => "puppet:///files/${tarball}",
    require => File[$workdir],
  }
  exec { 'tomcat-unpack':
    cwd         => $tomcat::basedir,
    command     => "/bin/tar -zxf '${workdir}/${tarball}'",
    require     => File['tomcat-tarball'],
    creates     => "${tomcat::basedir}/${subdir}",
  }
  file { "${tomcat::basedir}/tomcat":
    ensure  => link,
    target  => "${tomcat::basedir}/${subdir}",
  }
}
