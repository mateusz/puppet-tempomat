class tempomat::install inherits tempomat {

	Exec {
		path => "/sbin:/bin:/usr/bin:/usr/sbin",
	}

	if $tempomat::http_proxy {
		Archive {
			proxy_server => $tempomat::http_proxy
		}
	}

	archive { "/tmp/doctor-${tempomat::version}-linux-amd64.tgz":
		ensure => $tempomat::ensure,
		provider => 'curl',
		source => "https://github.com/mateusz/tempomat/releases/download/${tempomat::version}/doctor-${tempomat::version}-linux-amd64.tgz",
		cleanup => true,
		extract => true,
		extract_path => "/usr/local/bin",
		creates => "/usr/local/bin/doctor",
	}->archive { "/tmp/tempomat-${tempomat::version}-linux-amd64.tgz":
		ensure => $tempomat::ensure,
		provider => 'curl',
		source => "https://github.com/mateusz/tempomat/releases/download/${tempomat::version}/tempomat-${tempomat::version}-linux-amd64.tgz",
		cleanup => true,
		extract => true,
		extract_path => "/usr/local/bin",
		creates => "/usr/local/bin/tempomat",
	}->exec { "setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/tempomat":
		# Gives permission to bind to ports < 1024
		unless => 'getcap /usr/local/bin/tempomat | grep cap_net_bind_service+eip',
	}
}
