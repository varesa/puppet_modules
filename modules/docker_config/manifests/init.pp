class docker_config {
    file {
      "/etc/systemd/system/docker.service":
        ensure => 'file',
        content => template('docker_config/docker.service.erb'),
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
}
