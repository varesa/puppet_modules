

if $operatingsystem == 'fedora' and $operatingsystemmajrelease > 17 {
  Service {
    provider => "systemd"
  }
}
