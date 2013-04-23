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
    exec { "create-parent-dir-${filename}":
      path    => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${dir}",
      creates => $dir,
      user    => $user,
      group   => $group,
      require => Exec["tomcat-unpack-${user}"],
    }
  }
  if $source {
    file { $filename:
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      source   => $source,
      require  => Exec[
        "tomcat-unpack-${user}",
        "create-parent-dir-${filename}"
      ],
    }
  }
  elsif $content {
    file { $filename:
      ensure   => present,
      owner    => $user,
      group    => $group,
      mode     => $mode,
      content  => $content,
      require  => Exec[
        "tomcat-unpack-${user}",
        "create-parent-dir-${filename}"
      ],
    }
  }
  else {
    fail( 'tomcat::file requires either a source or content parameter' )
  }
}
