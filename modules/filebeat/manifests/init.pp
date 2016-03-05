class filebeat {
    exec {
      "fb_repo":
        command => 'service goferd restart && sleep 15 && pulp-consumer rpm bind --repo-id elastic-beats-x86_64',
        path    => ['/bin', '/sbin', '/usr/bin/', '/usr/sbin/'],
        unless  => 'grep -q "elastic-beats-x86_64" /etc/yum.repos.d/pulp.repo',
    }

    package {
      "filebeat":
        ensure   => 'installed',
    }

    file { "filebeat.yml":
        path   => "/etc/filebeat/filebeat.yml",
        ensure => 'file',
        source => 'puppet:///modules/filebeat/filebeat.yml',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    if $operatingsystemmajrelease < 7 {
      $unless = "service filebeat status"  
    } else {
      $unless = 'systemctl status filebeat | grep -q "loaded"'
    }

    exec { "add_service":
      command => 'chkconfig --add filebeat',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      unless  => $unless
    }
    


    service {
      "filebeat":
        ensure   => 'running',
        enable   => 'true',
    }


    Exec['fb_repo']
    -> Package["filebeat"] 
    -> File['filebeat.yml']
    -> Exec['add_service']
    -> Service["filebeat"]
}
