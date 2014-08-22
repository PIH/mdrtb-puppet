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
	
	package { 'libaio1':
		ensure  => latest,
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
		creates   => '/etc/init.d/mysql.server',  # this just means that this not execute if this mysql.server file has been created (i.e., prevents this from being run twice)
		cwd     => $mysql_home,
		command => "scripts/mysql_install_db --no-defaults --user=mysql --basedir=${mysql_home} --datadir=${mysql_home}/data",	
		logoutput	=> true,
		timeout	=> 0, 
	} -> 

	exec { 'change-mysql-ownership-to-root':
		cwd     => $mysql_home,
		command => "chown -R root .&&chown -R ${mysql_sys_user_name} data",		
		timeout	=> 0, 
		logoutput	=> true,
	} ->	

	exec { 'configure-mysql':
		cwd     => $mysql_home,
		command => "bash -c ${mysql_home}/bin/mysqld_safe --user=mysql &",		
		logoutput	=> true,
		timeout	=> 0, 
	} -> 

	file { '/etc/init.d/mysql.server':
		ensure  => present,
		source  => "${mysql_home}/support-files/mysql.server",
		mode    => '0755',
		owner   => $mysql_sys_user_name,
		group   => $mysql_sys_user_group,    
	}	

}