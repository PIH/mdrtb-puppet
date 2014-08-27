class pih_tomcat (
    $tomcat = hiera('tomcat'),
    $services_enable = hiera('services_enable'),
    $java_memory_parameters = hiera('java_memory_parameters'),
    $java_profiler = hiera('java_profiler'),
    $java_debug_parameters = hiera('java_debug_parameters'),
  ){

  require pih_java

  $java_home = $pih_java::java_home
  $tomcat_zip = 'apache-tomcat-6.0.36.tar.gz'
  $dest_tomcat_zip = "/usr/local/${tomcat_zip}"
  $version = '6.0.36'
  $tomcat_home = /usr/local/apache-tomcat-${version}


  notify{"java_home= ${java_home}": }

  user { $tomcat:
    ensure => 'present',
    home   => "/home/${tomcat}",
    shell  => '/bin/sh',
  } ->

  file { "/home/${tomcat}":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
  } ->

  file { $dest_tomcat_zip:
    ensure  => file,
    source  => "puppet:///modules/pih_tomcat/${tomcat_zip}",    
    mode    => '0755',
  } -> 

  exec { 'tomcat-unzip':
    cwd     => '/usr/local',
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_tomcat_zip}",
    unless  => "test -d ${tomcat_home}",   
  } ->

  file { "/usr/local/apache-tomcat-${version}":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    recurse => true,    
  } ->

  file { "/usr/local/${tomcat}":
    ensure  => 'link',
    target  => "/usr/local/apache-tomcat-${version}",
    owner   => $tomcat,
    group   => $tomcat,    
  } ->

  file { "/etc/init.d/${tomcat}":
    ensure  => file,
    mode    => '0755',
    content => template("pih_tomcat/init.erb")
  } ->

  file { "/etc/default/${tomcat}":
    ensure  => file,
    content => template("pih_tomcat/default.erb")
  } ->

  file { "/etc/logrotate.d/${tomcat}":
    ensure  => file,
    source  => "puppet:///modules/pih_tomcat/logrotate",
  } ->

  service { $tomcat:
    enable  => $services_enable,
  }
}
