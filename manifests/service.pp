class tollbooth::service inherits tollbooth {

	if $tollbooth::debug {
		$debug_flag = ' -debug '
	}

	if $tollbooth::trusted_proxies {
		$trusted_proxies_string = join($tollbooth::trusted_proxies, ',')
		$trusted_proxies_flag = " -trusted-proxies $trusted_proxies_string"
	}

	::systemd::unit_file { "tollbooth.service":
		content => template("tollbooth/systemd_service.erb")
	} -> service { 'tollbooth':
		ensure => true,
		enable => true,
	}

}
