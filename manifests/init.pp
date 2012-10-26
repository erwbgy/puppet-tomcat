class tomcat (
  $version   = undef,
  $user      = 'tomcat',
  $group     = 'tomcat',
  $basedir   = '/opt',
  $workspace = '/root'
) {
  if $version == undef {
    fail('tomcat version parameter is required')
  }
  file { "${workspace}/tomcat":
    ensure  => directory,
  }
  Class['tomcat'] -> Class['sunjdk']
  $subdir  = "apache-tomcat-${version}"
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
    workspace => $workspace,
  }
}
