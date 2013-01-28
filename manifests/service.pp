define tomcat::service (
  $user,
  $group,
  $version,
  $basedir,
  $java_home,
  $java_opts,
  $min_mem,
  $max_mem,
) {
  $product_dir = "${basedir}/apache-tomcat-${version}"
  runit::service { "${user}-apache-tomcat":
    service     => 'tomcat',
    user        => $user,
    group       => $group,
    home        => $basedir,
  }
  file { "${basedir}/${user}/runit/tomcat/run":
    ensure  => present,
    mode    => '0555',
    owner   => $user,
    group   => $group,
    content => template('tomcat/run.erb'),
    require => File["${basedir}/${user}/runit/tomcat}"],
  }
  file { "${basedir}/${user}/service/tomcat":
    ensure  => link,
    target  => "${basedir}/${user}/runit/tomcat",
    owner   => $user,
    group   => $group,
    replace => false,
    require => File["${basedir}/${user}/runit/tomcat/run"],
  }
  file { "${basedir}/${user}/logs/tomcat":
    ensure  => directory,
    owner   => $user,
    group   => $group,
  }
  file { "${basedir}/${user}/logs/tomcat/repository":
    ensure  => link,
    owner   => $user,
    target  => "${basedir}/${user}/tomcat-${version}/repository/logs",
    require => File["${basedir}/${user}/logs/tomcat"],
  }
}
