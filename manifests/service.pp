class tempomat::service inherits tempomat {

	Exec {
		path => "/sbin:/bin:/usr/bin:/usr/sbin",
	}

	if $tempomat::debug {
		$debug_flag = ' -debug '
	}

	if $tempomat::trusted_proxies {
		$trusted_proxies_string = join($tempomat::trusted_proxies, ',')
		$trusted_proxies_flag = " -trusted-proxies $trusted_proxies_string"
	}

	if $tempomat::ensure!='absent' {

		file { '/etc/systemd/system/tempomat.service':
			ensure => file,
			owner  => 'root',
			group  => 'root',
			mode   => '0644',
			content => template("tempomat/systemd_service.erb")
		} ~> exec { 'systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
			refreshonly => true,
		} -> service { 'tempomat':
			ensure => 'running',
			enable => true,
		}

	} else {

		service { 'tempomat':
			ensure => 'stopped',
		} -> file { '/etc/systemd/system/tempomat.service':
			ensure => 'absent',
		} ~> exec { 'systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
			refreshonly => true,
		}

	}

}
