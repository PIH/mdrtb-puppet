class pih_mysql {
    
	$mysql_sys_user_group = hiera('mysql_sys_user_group')
	$mysql_sys_user_name = hiera('mysql_sys_user_name')

	$mysql_home = "/usr/local/mysql"
	$mysql_tar = "mysql-5.6.20.tar.gz"
	$mysql_dest = "/usr/local/${mysql_tar}"

	group { $mysql_sys_user_group:
		ensure => 'present',
	} ->

	user { $mysql_sys_user_name:
		ensure	=> 'present',
		gid		=> $mysql_sys_user_group,
	} ->

	file { $mysql_home:
		ensure  => directory,
		owner	=> $mysql_sys_user_name,
		group 	=> $mysql_sys_user_group,
		recurse	=> true,
	} -> 
	
	file { $mysql_dest:
		ensure  => file,
		source	=> "puppet:///modules/pih_mysql/${mysql_tar}",		
		mode    => '0755',
	} -> 

	exec { 'unzip-mysql':
		cwd     => '/usr/local',
		command => "tar -xzf ${mysql_dest} -C ${mysql_home}",		
		timeout	=> 0, 
	} ->

	exec { 'change-mysql-ownership':
		cwd     => $mysql_home,
		command => "chown -R ${mysql_sys_user_name} .&&chgrp -R ${mysql_sys_user_group} .",		
		timeout	=> 0, 
	} ->

	exec { 'install-mysql':
		cwd     => $mysql_home,
		command => "scripts/mysql_install_db --user=mysql",		
		timeout	=> 0, 
	}


}