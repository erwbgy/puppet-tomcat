define tomcat::config::template(
  $template,
  $owner    = undef,
  $group    = undef,
  $mode     = undef,
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
