define tomcat::file (
  $group,
  $mode,
  $product_dir,
  $user,
  $content  = undef,
  $source   = undef,
) {
  $filename = $title
  if $filename =~ /^(.*?)\/([^\/]+)$/ {
    $dir = $1
    exec { "create-parent-dir-${product_dir}/${filename}":
      path    => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${product_dir}/${dir}",
      creates => "${product_dir}/${dir}",
    }
  }
  if $source {
    file { "${product_dir}/${filename}":
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      source   => $source,
      require  => Exec[
        "tomcat-unpack-${user}",
        "create-parent-dir-${product_dir}/${filename}"
      ],
    }
  }
  elsif $content {
    file { "${product_dir}/${filename}":
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      content  => $content,
      require  => Exec[
        "tomcat-unpack-${user}",
        "create-parent-dir-${product_dir}/${filename}"
      ],
    }
  }
  else {
    fail( 'tomcat::file requires either a source or content parameter' )
  }
}
