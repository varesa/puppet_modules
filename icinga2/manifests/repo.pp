class icinga2::repo {
	if $osfamily == "RedHat" {
		if $operatingsystem == "Fedora" {
			Exec {
				command => "wget http://packages.icinga.org/fedora/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo",
				creates => "/etc/yum.repos.d/ICINGA-release.repo",
				path => ["/usr/bin/"],
			}
		} else {
			Exec {
				command => "wget http://packages.icinga.org/epel/ICINGA-release.repo -O /etc/yum.repos.d/ICINGA-release.repo",
				creates => "/etc/yum.repos.d/ICINGA-release.repo",
				path => ["/usr/bin/"],
			}
		}
	} else {
		warning("OS not supported")
	}
}
