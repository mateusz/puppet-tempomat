class tollbooth::service inherits tollbooth {

	Exec {
		path => "/sbin:/bin:/usr/bin:/usr/sbin",
	}

	if $tollbooth::debug {
		$debug_flag = ' -debug '
	}

	if $tollbooth::trusted_proxies {
		$trusted_proxies_string = join($tollbooth::trusted_proxies, ',')
		$trusted_proxies_flag = " -trusted-proxies $trusted_proxies_string"
	}

	if $tollbooth::ensure!='absent' {

		file { '/etc/systemd/system/tollbooth.service':
			ensure => file,
			owner  => 'root',
			group  => 'root',
			mode   => '0644',
			content => template("tollbooth/systemd_service.erb")
		} ~> exec { 'systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
			refreshonly => true,
		} -> service { 'tollbooth':
			ensure => 'running',
			enable => true,
		}

	} else {

		service { 'tollbooth':
			ensure => 'stopped',
		} -> file { '/etc/systemd/system/tollbooth.service':
			ensure => 'absent',
		} ~> exec { 'systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
			refreshonly => true,
		}

	}

}
