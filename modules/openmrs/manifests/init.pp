class openmrs (
    $openmrs_db = hiera('openmrs_db'),
    $openmrs_db_user = hiera('openmrs_db_user'),
    $openmrs_db_password = hiera('openmrs_db_password'),
    $openmrs_auto_update_database = hiera('openmrs_auto_update_database'),    
    $tomcat = hiera('tomcat'),
    

  ){


  file { "/home/${tomcat}/.OpenMRS":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',
    require => User[$tomcat]
  }

  file { "/home/${tomcat}/.OpenMRS/mirebalais.properties":
    ensure  => present,
    content => template('openmrs/mirebalais.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',
    require => File["/home/${tomcat}/.OpenMRS"]
  }

  file { "/home/${tomcat}/.OpenMRS/feature_toggles.properties":
    ensure  => present,
    content => template('openmrs/feature_toggles.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',
    require => File["/home/${tomcat}/.OpenMRS"]
  }

  file { "/home/${tomcat}/.OpenMRS/mirebalais-runtime.properties":
    ensure  => present,
    content => template('openmrs/mirebalais-runtime.properties.erb'),
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0644',
    require => File["/home/${tomcat}/.OpenMRS"]
  }

   # install file to customize apps for production (removing export apps) or reporting server (only including export apps)
   file { "/home/${tomcat}/.OpenMRS/custom-appframework-config.json":
	ensure => present,
	source => "puppet:///modules/openmrs/${$custom_appframework_config_filename}",
	owner   => $tomcat,
	group   => $tomcat,
	mode    => '0644',
	require => File["/home/${tomcat}/.OpenMRS"]
   }

}
