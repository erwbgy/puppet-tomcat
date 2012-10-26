class tomcat (
  $version   = undef,
  $user      = 'tomcat',
  $group     = 'tomcat',
  $basedir   = '/opt',
  $workspace = '/root/tomcat',
  $use_hiera = false
) {
  if $use_hiera {
    $tomcat = hiera['tomcat']
    if $tomcat == undef {
      fail('tomcat hash not found in hiera config')
    }
    $_version = $tomcat['version'] ? {
      undef   => $version,
      default => $version
    }
    $_user = $tomcat['user'] ? {
      undef   => $user,
      default => $user
    }
    $_group = $tomcat['group'] ? {
      undef   => $group,
      default => $group
    }
    $_basedir = $tomcat['basedir'] ? {
      undef   => $basedir,
      default => $basedir
    }
    $_workspace = $tomcat['workspace'] ? {
      undef   => $workspace,
      default => $workspace
    }
  }
  else {
    $_version   = $version
    $_user      = $user
    $_group     = $group
    $_basedir   = $basedir
    $_workspace = $workspace
  }
  if $_version == undef {
    fail('tomcat version parameter is required')
  }
  file { $_workspace:
    ensure  => directory,
  }
  exec { 'tomcat-basedir':
    command => "/bin/mkdir -p ${_basedir}",
    creates => $_basedir,
  }
  #Class['tomcat'] -> Class['sunjdk']
  class { 'tomcat::install':
    version   => $_version,
    user      => $_user,
    group     => $_group,
    basedir   => $_basedir,
    workspace => $_workspace,
  }
  class { 'tomcat::config':
    version   => $_version,
    basedir   => $_basedir,
  }
}
