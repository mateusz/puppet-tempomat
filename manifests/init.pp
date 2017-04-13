class tempomat(
	$ensure = 'present',
	$version = '0.2.3',
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

	class { 'tempomat::install': }->
	class { 'tempomat::service': }

}
