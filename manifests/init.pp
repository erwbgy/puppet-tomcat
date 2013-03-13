class tomcat (
  $version          = '7.0.37',
  $basedir          = '/opt/tomcat',
  $bind_address     = $::fqdn,
  $files            = {},
  $templates        = {},
  $down             = false,
  $extra_jars       = [],
  $group            = 'tomcat',
  $java_home        = '/usr/java/latest',
  $java_opts        = '',
  $logdir           = '/var/log/tomcat',
  $min_mem          = '1024m',
  $max_mem          = '2048m',
  $workspace        = '/root/tomcat',
) {
  $tomcat = hiera_hash('tomcat::instances', undef)
  if $tomcat {
    create_resources('tomcat::instance', $tomcat)
  }
}
