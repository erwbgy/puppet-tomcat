define tomcat::service (
  $basedir,
  $bind_address,
  $check_port,
  $config,
  $cpu_affinity,
  $dependencies,
  $down,
  $filestore,
  $gclog_enabled,
  $gclog_numfiles,
  $gclog_filesize,
  $group,
  $localhost,
  $logdir,
  $java_home,
  $java_opts,
  $jolokia,
  $jolokia_address,
  $jolokia_cron,
  $jolokia_port,
  $jolokia_version,
  $max_mem,
  $min_mem,
  $product,
  $ulimit_nofile,
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
  file { "${basedir}/runit/tomcat/check":
    ensure  => present,
    mode    => '0555',
    owner   => $user,
    group   => $group,
    content => template('tomcat/check.erb'),
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
  if $jolokia_cron {
    cron { "tomcat-${user}-jvm_memory_os":
      command => "${basedir}/${product}-${version}/bin/jvm_memory_os",
      user    => $user,
      require => File["${basedir}/${product}-${version}/bin/jvm_memory_os"],
    }
  }
}
