define tomcat::instance (
  $basedir          = $::tomcat::basedir,
  $bind_address     = $::tomcat::bind_address,
  $down             = $::tomcat::down,
  $files            = $::tomcat::files,
  $group            = $::tomcat::group,
  $java_home        = $::tomcat::java_home,
  $java_opts        = $::tomcat::java_opts,
  $logdir           = $::tomcat::logdir,
  $max_mem          = $::tomcat::max_mem,
  $min_mem          = $::tomcat::min_mem,
  $templates        = $::tomcat::templates,
  $version          = $::tomcat::version,
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

  create_resources( 'tomcat::file', $files,
    { user => $user, group => $group, product_dir => $product_dir }
  )

  create_resources( 'tomcat::template', $templates,
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
    down         => $down,
  }

}
