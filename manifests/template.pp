define tomcat::template(
  $template,
  $group    = undef,
  $mode     = undef,
  $owner    = undef,
  $schedule = 'always',
) {
  $filename = $title
  file { "${product_dir}/${filename}":
    owner    => $owner,
    group    => $group,
    mode     => $mode,
    schedule => $schedule,
    content  => template($template),
  }
}
