class tomcat (
  $version   = undef,
  $user      = 'tomcat',
  $group     = 'tomcat',
  $basedir   = '/opt',
  $workspace = '/root/tomcat'
) {
  if $version == undef {
    fail('tomcat version parameter is required')
  }
  file { $workspace:
    ensure  => directory,
  }
  exec { 'tomcat-basedir':
    command => "/bin/mkdir -p ${basedir}",
    creates => $basedir,
  }
  Class['tomcat'] -> Class['sunjdk']
  class { 'tomcat::install':
    version   => $version,
    user      => $user,
    group     => $group,
    basedir   => $basedir,
    workspace => $workspace,
  }
  class { 'tomcat::config':
    version   => $version,
    basedir   => $basedir,
  }
}
