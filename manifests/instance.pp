define tomcat::instance (
  $version          = $::tomcat::version,
  $basedir          = $::tomcat::basedir,
  $bind_address     = $::tomcat::bind_address,
  $config_files     = $::tomcat::config_files,
  $config_templates = $::tomcat::config_templates,
  $extra_jars       = $::tomcat::extra_jars,
  $group            = $::tomcat::group,
  $java_home        = $::tomcat::java_home,
  $java_opts        = $::tomcat::java_opts,
  $logdir           = $::tomcat::logdir,
  $min_mem          = $::tomcat::min_mem,
  $max_mem          = $::tomcat::max_mem,
  $workspace        = $::tomcat::workspace,
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
    'tomcat::config::file',
    $config_files,
    { user => $user, group => $group, product_dir => $product_dir }
  )

  create_resources(
    'tomcat::config::template',
    $config_templates,
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
