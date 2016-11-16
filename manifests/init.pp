class tollbooth(
	$ensure = 'present',
	$version = '0.1.0',
	$debug = false,
	$trusted_proxies = ['127.0.0.1'],
	$user = 'www-data',
	$group = 'www-data',
	$listen_port = 80,
	$backend = 'http://localhost:81',
	$http_proxy = undef,
) {

	validate_string($version)
	validate_bool($debug)
	validate_array($trusted_proxies)
	validate_string($user)
	validate_string($group)
	validate_numeric($listen_port)
	validate_string($backend)
	if $http_proxy {
		validate_string($http_proxy)
	}

	class { 'tollbooth::install': }->
	class { 'tollbooth::service': }

}
