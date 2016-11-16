class tollbooth::service inherits tollbooth {

	if $tollbooth::debug {
		$debug_flag = ' -debug '
	}

	if $tollbooth::trusted_proxies {
		$trusted_proxies_string = join($tollbooth::trusted_proxies, ',')
		$trusted_proxies_flag = " -trusted-proxies $trusted_proxies_string"
	}

	if $tollbooth::ensure=='present' {

		::systemd::unit_file { "tollbooth.service":
			ensure => $tollbooth::ensure,
			content => template("tollbooth/systemd_service.erb")
		} -> service { 'tollbooth':
			ensure => $service_ensure,
			enable => true,
		}

	} else {

		service { 'tollbooth':
			ensure => 'stopped',
		}->::systemd::unit_file { "tollbooth.service":
			ensure => absent,
		}

	}

}
