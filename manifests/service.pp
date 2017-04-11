class tempomat::service inherits tempomat {

	Exec {
		path => "/sbin:/bin:/usr/bin:/usr/sbin",
	}

	if $tempomat::ensure!='absent' {

		file { '/etc/tempomat.json':
			ensure => file,
			owner  => 'root',
			group  => 'root',
			mode   => '0644',
			content => template("tempomat/tempomat.json.erb")
		} -> file { '/etc/systemd/system/tempomat.service':
			ensure => file,
			owner  => 'root',
			group  => 'root',
			mode   => '0644',
			content => template("tempomat/systemd_service.erb")
		} ~> exec { 'tempomat-systemctl-daemon-reload':
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
		} -> file { '/etc/tempomat.json':
			ensure => 'absent',
		} ~> exec { 'tempomat-systemctl-daemon-reload':
			command => 'systemctl daemon-reload',
			refreshonly => true,
		}

	}

}
