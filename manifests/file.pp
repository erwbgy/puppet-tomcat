define tomcat::file (
  $group,
  $mode,
  $product_dir,
  $user,
  $content  = undef,
  $source   = undef,
) {
  $filename = $title
  if defined($source) {
    file { "${product_dir}/${filename}":
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      source   => $source,
      require  => Exec["tomcat-unpack-${user}"],
    }
  }
  elsif defined($content) {
    file { "${product_dir}/${filename}":
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      content  => $content,
      require  => Exec["tomcat-unpack-${user}"],
    }
  }
  else {
    fail( 'tomcat::file requires either a source or content parameter' )
  }
}
