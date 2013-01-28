define tomcat::instance (
  $version,
  $bind_address = $::fqdn,
  $config_files = {},
  $extra_jars   = [],
  $group        = 'tomcat',
  $basedir      = '/home',
  $java_home    = '/usr/java/latest',
  $java_opts    = '',
  $min_mem      = '1024m',
  $max_mem      = '2048m',
  $workspace    = '/root/tomcat',
) {
  $user        = $title
  $product_dir = "${basedir}/${user}/apache-tomcat-${version}"

  if ! defined(File["/etc/runit/${user}"]) {
    runit::user { $user: basedir => $basedir, group => $group }
  }

  tomcat::install { "${user}-apache-tomcat":
    version     => "apache-tomcat-${version}",
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

  tomcat::service { "${user}-apache-tomcat":
    user      => $user,
    group     => $group,
    version   => $version,
    basedir   => $basedir,
    java_home => $java_home,
    java_opts => $java_opts,
    min_mem   => $min_mem,
    max_mem   => $max_mem,
  }

  create_resources(
    'tomcat::config_file',
    $config_files,
    { user => $user, group => $group, product_dir => $product_dir }
  )
}
