define tomcat::template(
  $template,
  $group    = undef,
  $mode     = undef,
  $owner    = undef,
  $schedule = 'always',
) {
  file { $title:
    owner    => $owner,
    group    => $group,
    mode     => $mode,
    schedule => $schedule,
    content  => template($template),
  }
}
