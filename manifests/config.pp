class tomcat::config (
  version => undef
  basedir => undef
) {
  # TODO: /etc/sysctl.conf changes
  # TODO: /etc/security/limits.conf changes
  $subdir = "apache-tomcat-${version}"
  file { [
    "${basedir}/${subdir}/conf/catalina.policy",
    "${basedir}/${subdir}/conf/catalina.properties",
    "${basedir}/${subdir}/conf/context.xml",
    "${basedir}/${subdir}/conf/logging.properties",
    "${basedir}/${subdir}/conf/server.xml",
    "${basedir}/${subdir}/conf/tomcat-users.xml",
    "${basedir}/${subdir}/conf/web.xml",
  ]:
    mode    => '0444',
  }
  iptables::allow{ 'tomcat-http':  port => '8080', protocol => 'tcp' }
}
