# == Class: ikioma_ca
#
# Full description of class ikioma_ca here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'ikioma_ca':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class ikioma_ca {
    file { '/etc/pki/ca-trust/source/anchors/ikioma.ca.crt':
	ensure => 'present',
	source => 'puppet:///modules/ikioma_ca/ikioma.ca.crt',
    }
    
    exec { "UpdateCA":
	path => ["/usr/bin/", "/bin"],
	command => "update-ca-trust enable && update-ca-trust && touch /etc/pki/ca-trust/ikioma-ca-installed",
	creates => "/etc/pki/ca-trust/ikioma-ca-installed"
    }
    
    File['/etc/pki/ca-trust/source/anchors/ikioma.ca.crt'] -> Exec["UpdateCA"]

}
