class tempomat(
	$ensure = 'present',
	$version = '0.2.0',
	$user = 'www-data',
	$group = 'www-data',
	$http_proxy = undef,
	$config = {},
) {

	validate_string($version)
	validate_string($user)
	validate_string($group)
	if $http_proxy {
		validate_string($http_proxy)
	}
	validate_hash($config)
	if $config['logFile'] {
		fail('logFile is forbidden, automatically set by this module')
	}
	if $config['statsFile'] {
		fail('statsFile is forbidden, automatically set by this module')
	}

	class { 'tempomat::install': }->
	class { 'tempomat::service': }

}
