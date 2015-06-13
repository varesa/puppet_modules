# == Class: pulp_client_setup
#
# Full description of class pulp_client_setup here.
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
#  class { 'pulp_client_setup':
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
class pulp_client_setup {
    include ikioma_ca
    
    include epel
    include pulp

    # Prevent overlapping repos
    file { "/etc/yum.repos.d/rhel-pulp.repo":
	ensure => "absent",
    }
    
    class { 'pulp::consumer':
        ensure => "present",
        server => "pulp.ikioma"
    }
        
    exec { "Register":
        path => "/usr/bin/",
        command => "pulp-consumer -u puppet -p goferd134 register --consumer-id ${fqdn}",
        creates => "/etc/pki/pulp/consumer/consumer-cert.pem"
    }
    
    Class['ikioma_ca'] -> Class['epel'] -> Class['pulp'] -> File["/etc/yum.repos.d/rhel-pulp.repo"] -> Class['pulp::consumer'] -> Exec["Register"]
}
