class tomcat {
  $tomcat = hiera_hash('tomcat', undef)
  if $tomcat {
    create_resources('tomcat::instance', $tomcat)
  }
}
