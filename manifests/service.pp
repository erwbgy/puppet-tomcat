define tomcat::service (
  $basedir,
  $config,
  $down,
  $group,
  $logdir,
  $java_home,
  $java_opts,
  $max_mem,
  $min_mem,
  $product,
  $user,
  $version,
) {
  $product_dir = "${basedir}/${product}-${version}"
  runit::service { "${user}-${product}":
    service     => 'tomcat',
    basedir     => $basedir,
    logdir      => $logdir,
    user        => $user,
    group       => $group,
    down        => $down,
    timestamp   => false,
  }
  file { "${basedir}/runit/tomcat/run":
    ensure  => present,
    mode    => '0555',
    owner   => $user,
    group   => $group,
    content => template('tomcat/run.erb'),
    require => Runit::Service["${user}-${product}"],
  }
  file { "${basedir}/service/tomcat":
    ensure  => link,
    target  => "${basedir}/runit/tomcat",
    owner   => $user,
    group   => $group,
    replace => false,
    require => Runit::Service["${user}-${product}"],
  }
}
