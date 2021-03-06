# == Class: ntp
#
# Full description of class ntp here.
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
#  class { 'ntp':
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
class ldap_auth {
    package { "sssd":
    	ensure => "installed",
    }
    
    package { "sssd-ldap":
        ensure => "installed",
    }
    
    file { "/etc/sssd/sssd.conf":
        ensure => "present",
        source => "puppet:///modules/ldap_auth/sssd.conf",
        mode => "600"
    }

    file { "/etc/nsswitch.conf":
        ensure => "present",
        source => "puppet:///modules/ldap_auth/nsswitch.conf"
    }

    file { "/etc/pam.d/system-auth":
        ensure => "present",
        source => "puppet:///modules/ldap_auth/system-auth"
    }
    
    file { "/etc/pam.d/password-auth-ac":
        ensure => "present",
        source => "puppet:///modules/ldap_auth/password-auth-ac"
    }
    
    file { "/etc/pam.d/password-auth":
        ensure => "link",
        target => "/etc/pam.d/password-auth-ac"
    }
    
    service { "sssd":
        ensure => "running"
    }
    
    Package["sssd"] -> File["/etc/sssd/sssd.conf"] -> File["/etc/nsswitch.conf"] -> File["/etc/pam.d/system-auth"] -> File["/etc/pam.d/password-auth-ac"] -> File["/etc/pam.d/password-auth"] -> Service["sssd"]
}
