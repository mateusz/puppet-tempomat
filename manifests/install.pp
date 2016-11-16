class tollbooth::install inherits tollbooth {

	Exec {
		path => "/sbin:/bin:/usr/bin:/usr/sbin",
	}

	if $tollbooth::http_proxy {
		Archive {
			proxy_server => $tollbooth::http_proxy
		}
	}

	archive { "/tmp/tollbooth-${tollbooth::version}-linux-amd64.tgz":
		ensure => $tollbooth::ensure,
		provider => 'curl',
		source => "https://github.com/mateusz/tollbooth/releases/download/${tollbooth::version}/tollbooth-${tollbooth::version}-linux-amd64.tgz",
		cleanup => true,
		extract => true,
		extract_path => "/usr/local/bin",
		creates => "/usr/local/bin/tollbooth",
	}->exec { "setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/tollbooth":
		# Gives permission to bind to restricted ports.
		creates => '/var/lib/solr/solr4.war',
		unless => 'getcap /usr/local/bin/tollbooth | grep cap_net_bind_service+eip',
	}->file { '/var/log/tollbooth':
		ensure => 'directory',
		mode => 0755,
		owner => $user,
		group => $group,
		require => [ User[$user], Group[$group], ],
	}

}
