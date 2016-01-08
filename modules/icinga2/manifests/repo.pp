class icinga2::repo {
	warning("Test")
	if $osfamily == "RedHat" {
		if $operatingsystem == "Fedora" {
			exec { "icinga2-repo":
				command => "wget http://packages.icinga.org/fedora/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo",
				creates => "/etc/yum.repos.d/ICINGA-release.repo",
				path => ["/usr/bin/"],
			}
		} else {
			exec { "icinga2-repo":
				command => "wget http://packages.icinga.org/epel/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo",
				creates => "/etc/yum.repos.d/ICINGA-release.repo",
				path => ["/usr/bin/"],
			}
		}
	} else {
		warning("OS not supported")
	}
}
