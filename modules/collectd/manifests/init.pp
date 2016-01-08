class collectd {

    if $operatingsystemmajrelease == 6 {
        package {
          "ghettoforge":
            name     => "gf-release",
            source   => "http://mirror.symnds.com/distributions/gf/el/6/gf/x86_64/gf-release-6-8.gf.el6.noarch.rpm",
            ensure   => 'installed',
            provider => 'rpm',

        }
        
        package { "collectd":
	          ensure          => "installed",
            provider        => "yum",
            install_options => "--enablerepo=gf-plus"
        }

        Package['ghettoforge'] -> Package['collectd']
    } else {
        package { "collectd":
	          ensure          => "installed",
            provider        => "yum",
        }
    }

    
    file { "collectd.conf":
        path   => "/etc/collectd.conf",
        ensure => 'file',
        source => 'puppet:///modules/collectd/collectd.conf',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }    

    file { "plugins_collect.conf":
        path    => "/etc/collectd.d/plugins_collect.conf",
        ensure  => 'file',
        source  => 'puppet:///modules/collectd/plugins_collect.conf',
        replace => 'false',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { "plugins_write.conf":
        path   => "/etc/collectd.d/plugins_write.conf",
        ensure => 'file',
        source => 'puppet:///modules/collectd/plugins_write.conf',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    file { "filters_thresholds.conf":
        path   => "/etc/collectd.d/filters_thresholds.conf",
        ensure => 'file',
        source => 'puppet:///modules/collectd/filters_thresholds.conf',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    service {
      "collectd":
        ensure   => 'running',
        enable   => 'true',
    }


    Package["collectd"] 
    -> File['collectd.conf'] 
    -> File['plugins_collect.conf']
    -> File['plugins_write.conf']
    -> File['filters_thresholds.conf']
    -> Service["collectd"]
}
