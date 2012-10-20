class tomcat::config {
  # TODO: /etc/sysctl.conf changes
  # TODO: /etc/security/limits.conf changes
  file { [
    "${tomcat::basedir}/tomcat/conf/catalina.policy",
    "${tomcat::basedir}/tomcat/conf/catalina.properties",
    "${tomcat::basedir}/tomcat/conf/context.xml",
    "${tomcat::basedir}/tomcat/conf/logging.properties",
    "${tomcat::basedir}/tomcat/conf/server.xml",
    "${tomcat::basedir}/tomcat/conf/tomcat-users.xml",
    "${tomcat::basedir}/tomcat/conf/web.xml",
  ]:
    mode    => '0444',
  }
  iptables::allow{ 'tomcat-http':  port => '8080', protocol => 'tcp' }
}
