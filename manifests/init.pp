class tomcat (
  $version = '7.0.32'
) {
  $workdir = '/var/lib/puppet/workspace/tomcat'
  file { $workdir:
    ensure  => directory,
    require => File['/var/lib/puppet/workspace']
  }
  include user, iptables
  $basedir = '/opt'
  $user    = 'tomcat'
  $group   = 'tomcat'
  realize( User[$user] )
  Class['tomcat'] -> Class['sunjdk']
  include tomcat::install
  include tomcat::config
}
