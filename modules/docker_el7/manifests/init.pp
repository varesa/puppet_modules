class docker_el7 {
    exec {
      "docker_repo":
        command => 'service goferd restart && sleep 15 && pulp-consumer rpm bind --repo-id docker-el7-x86_64',
        path    => ['/bin', '/sbin', '/usr/bin/', '/usr/sbin/'],
        unless  => 'grep -q "docker-el7-x86_64" /etc/yum.repos.d/pulp.repo',
    }

    package {
      "docker-engine":
        ensure   => 'installed',
    }

    service {
      "docker":
        ensure   => 'running',
        enable   => 'true',
    }


    Exec['docker_repo']
    -> Package["docker-engine"] 
    -> Service["docker"]
}
