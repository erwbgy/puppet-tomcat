define tomcat::instance (
  $basedir          = $::tomcat::basedir,
  $config           = $::tomcat::config,
  $cpu_affinity     = $::tomcat::cpu_affinity,
  $down             = $::tomcat::down,
  $files            = $::tomcat::files,
  $group            = $::tomcat::group,
  $java_home        = $::tomcat::java_home,
  $java_opts        = $::tomcat::java_opts,
  $logdir           = $::tomcat::logdir,
  $max_mem          = $::tomcat::max_mem,
  $min_mem          = $::tomcat::min_mem,
  $mode             = $::tomcat::mode,
  $remove_docs      = $::tomcat::remove_docs,
  $remove_examples  = $::tomcat::remove_examples,
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
    {
      group       => $group,
      mode        => $mode,
      product_dir => $product_dir,
      user        => $user,
    }
  )

  create_resources( 'tomcat::template', $templates,
    {
      basedir      => $basedir,
      config       => $config,
      cpu_affinity => $cpu_affinity,
      down         => $down,
      group        => $group,
      java_home    => $java_home,
      java_opts    => $java_opts,
      logdir       => $logdir,
      max_mem      => $max_mem,
      min_mem      => $min_mem,
      mode         => $mode,
      product_dir  => $product_dir,
      user         => $user,
      version      => $version,
      workspace    => $workspace,
    }
  )

  if $remove_docs {
    file { "${product_dir}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      purge   => true,
      backup  => false,
      require => Exec["tomcat-unpack-${user}"],
    }
  }

  if $remove_examples {
    file { "${product_dir}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      purge   => true,
      backup  => false,
      require => Exec["tomcat-unpack-${user}"],
    }
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
    config       => $config,
    cpu_affinity => $cpu_affinity,
    min_mem      => $min_mem,
    max_mem      => $max_mem,
    down         => $down,
  }

}
