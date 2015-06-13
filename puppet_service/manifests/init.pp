class puppet_service {
    package { "puppet":
	ensure => "installed",
    }
    
    service { "puppet":
	enable => true,
	ensure => "running",
    }
    
    Package["puppet"] -> Service["puppet"]
}
