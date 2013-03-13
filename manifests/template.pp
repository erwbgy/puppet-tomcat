define tomcat::template(
  $basedir,
  $bind_address,
  $down,
  $group,
  $java_home,
  $java_opts,
  $logdir,
  $max_mem,
  $min_mem,
  $mode,
  $product_dir,
  $template,
  $user,
  $version,
  $workspace,
) {
  $filename = $title
  file { "${product_dir}/${filename}":
    owner    => $user,
    group    => $group,
    mode     => $mode,
    content  => template($template),
    require  => Exec["tomcat-unpack-${user}"],
  }
}
