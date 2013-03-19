class tomcat (
  $version,
  $basedir          = '/opt/tomcat',
  $config           = {},
  $cpu_affinity     = undef,
  $down             = false,
  $files            = {},
  $group            = 'tomcat',
  $logdir           = '/var/log/tomcat',
  $java_home        = '/usr/java/latest',
  $java_opts        = '',
  $max_mem          = '2048m',
  $min_mem          = '1024m',
  $mode             = undef,
  $remove_docs      = true,
  $remove_examples  = true,
  $templates        = {},
  $workspace        = '/root/tomcat',
) {
  $tomcat = hiera_hash('tomcat::instances', undef)
  if $tomcat {
    create_resources('tomcat::instance', $tomcat)
  }
}
