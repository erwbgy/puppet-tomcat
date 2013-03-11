define tomcat::instance (
  $version,
  $basedir      = '/opt/tomcat',
  $bind_address = $::fqdn,
  $config_files = {},
  $extra_jars   = [],
  $group        = 'tomcat',
  $java_home    = '/usr/java/latest',
  $java_opts    = '',
  $logdir       = '/var/log/tomcat',
  $min_mem      = '1024m',
  $max_mem      = '2048m',
  $workspace    = '/root/tomcat',
) {
  $user        = $title
  $product     = 'apache-tomcat'
  $product_dir = "${basedir}/${product}-${version}"

  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
    }
  }

  include runit
  if ! defined(Runit::User[$user]) {
    runit::user { $user: 
      basedir => $basedir,
      group   => $group,
    }
  }

  tomcat::install { "${user}-${product}":
    version     => $version,
    user        => $user,
    group       => $group,
    basedir     => $basedir,
    workspace   => $workspace,
  }

  $file_paths = prefix($extra_jars, "${product_dir}/")
  tomcat::extra_jars { $file_paths:
    product_dir => $product_dir,
    destination => "${product_dir}/lib",
    user        => $user,
    group       => $group,
    require     => File[$product_dir],
  }

  tomcat::service { "${user}-${product}":
    basedir      => $basedir,
    logdir       => $logdir,
    product      => $product,
    user         => $user,
    group        => $group,
    version      => $version,
    java_home    => $java_home,
    java_opts    => $java_opts,
    bind_address => $bind_address,
    min_mem      => $min_mem,
    max_mem      => $max_mem,
  }

  create_resources(
    'tomcat::config_file',
    $config_files,
    { user => $user, group => $group, product_dir => $product_dir }
  )

  file { [ "${product_dir}/webapps/docs",
           "${product_dir}/webapps/examples", ]:
    ensure  => absent,
    recurse => true,
    force   => true,
    purge   => true,
    backup  => false,
  }
}
