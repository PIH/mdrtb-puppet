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

  $runtime_properties_file = "/home/${tomcat}/.OpenMRS/openmrs-runtime.properties"

  file { "/home/${tomcat}/.OpenMRS":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',
    require => User[$tomcat]
  } ->

  file { $runtime_properties_file:
    ensure  => present,
    content => template('openmrs/openmrs-runtime.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',    
  }


}
