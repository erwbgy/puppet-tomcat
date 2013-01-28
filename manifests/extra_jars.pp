define tomcat::extra_jars (
  $product_dir,
  $destination,
  $user,
  $group,
) {
  $jar_file = regsubst($title, "^${product_dir}/", '')
  file { "${destination}/${jar_file}":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0444',
    source  => "puppet:///files/tomcat/${jar_file}",
    require => File[$product_dir],
  }
}
