class pih_java {
    

    $oracle_java_installer = "oracle-java6-installer_6u45-0.deb"
    $tmp_oracle_java_installer = "/tmp/${oracle_java_installer}""
		
	file { $tmp_oracle_java_installer:
		ensure  => file,
		source	=> "puppet:///modules/pih_java/${oracle_java_installer}",		
	}

}