define tomcat::file (
  $group,
  $product_dir,
  $source,
  $user,
  $content = undef,
  $mode    = '0440',
  $source  = undef,
) {
  $filename = $title
  if defined($source) {
    file { "${product_dir}/${filename}":
      ensure  => present,
      owner   => $user,
      group   => $group,
      mode    => $mode,
      source  => $source,
      require => File[$product_dir],
    }
  }
  elsif defined($content) {
    file { "${product_dir}/${filename}":
      ensure  => present,
      owner   => $user,
      group   => $group,
      mode    => $mode,
      content => $content,
      require => File[$product_dir],
    }
  }
}
