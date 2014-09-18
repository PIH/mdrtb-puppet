class apache2 (
  $tomcat = hiera('tomcat'),
  $services_ensure = hiera('services_ensure'),
  $services_enable = hiera('services_enable'),
  $site_domain = hiera('site_domain'),
  $server_url = hiera('server_url')     
){

  require pih_java
  require pih_tomcat

  $java_home = $pih_java::java_home
  $tomcat_home = $pih_tomcat::tomcat_home

  package { 'apache2':
    ensure => installed,
  } ->

  package { 'libapache2-mod-jk':
    ensure => installed,
  } -> 

  file { '/etc/logrotate.d/apache2':
    ensure  => file,
    content  => template('apache2/logrotate.erb'),
  } ->
  
  service { 'apache2':
    ensure   => $services_ensure,
    enable   => $services_enable,
  } ->

  file { '/etc/apache2/workers.properties':
    ensure  => present,
    content => template('apache2/workers.properties.erb'),
  } ->

  file { '/etc/apache2/mods-available/jk.conf':
    ensure => present,
    source => 'puppet:///modules/apache2/jk.conf',
  } ->

  exec { 'enable_jk_modules':   
    command => "a2enmod jk&&service apache2 force-reload",    
    user    => 'root',
    logoutput => true,
    timeout => 0, 
  } ->  

  exec { 'optimize_for_gzip_compression':   
    command => "a2enmod deflate&&service apache2 force-reload",    
    user    => 'root',
    logoutput => true,
    timeout => 0, 
  } ->  

  file { '/var/www/favicon.ico':
    ensure => file,
    mode    => '0644',
    source => 'puppet:///modules/apache2/var/www/favicon.ico',    
  } ->

  file { '/var/www/index.html':
    ensure => file,
    mode    => '0644',
    content => template('apache2/index.html.erb'),
  } ->

  file { '/var/www/.htaccess':
    ensure => file,
    mode    => '0644',
    source => 'puppet:///modules/apache2/var/www/.htaccess',    
  } ->  


  file { '/etc/ssl/certs/_.pih-emr.org.crt':
    ensure => present,
    source => 'puppet:///modules/apache2/etc/ssl/certs/_.pih-emr.org.crt',
  } ->

  file { '/etc/ssl/certs/gd_bundle.crt':
    ensure => present,
    source => 'puppet:///modules/apache2/etc/ssl/certs/gd_bundle.crt',
  } ->

  file { '/etc/apache2/sites-available/ssl':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/apache2/sites-available/ssl',
  } ->

  file { '/etc/apache2/sites-available/default':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/apache2/sites-available/default',
  } ->

  file { "${tomcat_home}/conf/server.xml":
    ensure => file,
    owner   => $tomcat,
    group   => $tomcat,
    mode   => '0600',
    source => 'puppet:///modules/apache2/tomcat/conf/server.xml',
  } ->  

  exec { 'enable apache mods':
    command     => 'a2enmod ssl && a2ensite ssl && a2enmod rewrite && service apache2 restart',
    user        => 'root',
    logoutput => true,
    timeout => 0,     
    refreshonly => true,    
  } 
  
}
