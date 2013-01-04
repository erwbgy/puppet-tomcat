define tomcat::config_file (
  $product_dir,
  $source,
  $user,
  $group,
  $content = undef,
  $source  = undef,
  $mode    = '0440',
) {
  $filename = $title
  if defined($source) {
    file { "${product_dir}/conf/${filename}":
      ensure  => present,
      owner   => $user,
      group   => $group,
      mode    => $mode,
      source  => $source,
      require => File[$product_dir],
    }
  }
  elsif defined($content) {
    file { "${product_dir}/conf/${filename}":
      ensure  => present,
      owner   => $user,
      group   => $group,
      mode    => $mode,
      content => $content,
      require => File[$product_dir],
    }
  }
}
