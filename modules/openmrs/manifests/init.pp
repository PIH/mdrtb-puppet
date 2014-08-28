class openmrs (
    $openmrs_db = hiera('openmrs_db'),
    $openmrs_db_user = hiera('openmrs_db_user'),
    $openmrs_db_password = hiera('openmrs_db_password'),
    $openmrs_auto_update_database = hiera('openmrs_auto_update_database'),    
    $tomcat = hiera('tomcat'),
    
  ){

  require pih_java
  require pih_mysql
  require pih_tomcat

  $tomcat_home = $pih_tomcat::tomcat_home
  $openmrs_folder = "/home/${tomcat}/.OpenMRS"
  $runtime_properties_file = "${openmrs_folder}/openmrs-runtime.properties"
  $modules_tar = "modules.tar.gz"
  $dest_modules_tar = "${openmrs_folder}/${modules_tar}"

  $dest_openmrs_war = "${tomcat_home}/webapps/openmrs.war"

  notify{"tomcat_home= ${tomcat_home}": }
  notify{"tomcat= ${tomcat}": }

  file { $openmrs_folder:
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',
    require => User[$tomcat]
  } ->

  file { $dest_modules_tar:
    ensure  => file,
    owner   => $tomcat,
    group   => $tomcat,
    source  => "puppet:///modules/openmrs/${modules_tar}",    
    mode    => '0755',
  } -> 

  exec { 'modules-unzip':
    cwd     => $openmrs_folder,
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_modules_tar}",    
  } ->

  file { "${openmrs_folder}/modules":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => inf,
  } ->

  file { $dest_openmrs_war:
    ensure  => file,
    source  => "puppet:///modules/openmrs/openmrs.war",    
    mode    => '0755',
    owner   => $tomcat,
    group   => $tomcat,
  } -> 

  file { $runtime_properties_file:
    ensure  => present,
    content => template('openmrs/openmrs-runtime.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',    
  }


}
