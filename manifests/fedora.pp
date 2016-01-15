

if $operatingsystem == 'fedora' and $operatingsystemmajrelease > 17 {
  Service {
    provider => "systemd"
  }
}

if $operatingsystem == 'fedora' and $operatingsystemmajrelease > 21 {
  Package {
    provider => "dnf"
  }
}
