define tomcat::instance (
  $version          = $::tomcat::version,
  $basedir          = $::tomcat::basedir,
  $bind_address     = $::tomcat::bind_address,
  $files            = $::tomcat::files,
  $templates        = $::tomcat::templates,
  $down             = $::tomcat::down,
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

  $file_paths = prefix($files, "${product_dir}/")
  create_resources( 'tomcat::file', $file_paths,
    { user => $user, group => $group, product_dir => $product_dir }
  )

  $template_paths = prefix($templates, "${product_dir}/")
  create_resources( 'tomcat::template', $template_paths,
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
