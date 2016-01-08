class pulp::consumer($ensure = 'present', $server = $::fqdn, $conf_template = 'pulp/consumer.conf.erb') {
  package { [ 'pulp-agent',
              'pulp-consumer-client',
              'pulp-puppet-consumer-extensions',
              'pulp-puppet-handlers',
              'pulp-rpm-consumer-extensions',
              'pulp-rpm-handlers',
              'pulp-rpm-yumplugins',
              'python-gofer-qpid', ]:
    ensure => $ensure
  }

  # For the template
  $pulp_server = $server

  if $ensure == 'absent' {
    file { '/etc/pulp/consumer/consumer.conf':
      ensure  => 'absent',
    }

    service { 'goferd':
      ensure => 'stopped',
      before => Package['pulp-agent']
    }
  } else {
    file { '/etc/pulp/consumer/consumer.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      content => template($conf_template),
      require => Package['pulp-consumer-client']
    }

    service { 'goferd':
      ensure  => 'running',
      require => Package['pulp-agent']
    }
  }
}
