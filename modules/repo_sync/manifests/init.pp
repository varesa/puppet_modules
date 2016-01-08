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
class repo_sync {
    package { "repo_sync":
    	ensure => "installed",
    }
    
    group { "repo_sync":
        ensure => "present",
    }
    
    user { "repo_sync":
        ensure => "present",
        gid => "repo_sync",
        managehome => true,
    }
    
    file { "/home/repo_sync":
        ensure => "directory",
        owner => "repo_sync",
        group => "repo_sync",
        mode => "700",
    }
    
    file { "/home/repo_sync/.ssh":
        ensure => "directory",
        owner => "repo_sync",
        group => "repo_sync",
        mode => "700",
    }
    
    exec { "SSHKeys":
        path => "/usr/bin",
        command => "ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa",
        user => "repo_sync",
        creates => "/home/repo_sync/.ssh/id_rsa",
    }
    
    file { "/etc/cron.daily/repo_sync":
        ensure => "present",
        mode => "777",
        content => "#!/bin/sh
                    su -c \"repo_sync\" - repo_sync"
    }
    
    Package["repo_sync"] -> Group["repo_sync"] -> User["repo_sync"] -> File["/home/repo_sync"] -> File["/home/repo_sync/.ssh"] -> Exec["SSHKeys"]
}
