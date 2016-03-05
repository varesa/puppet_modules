class disable_stock_repos {
  if $operatingsystemmajrelease < 7 {
    $src = "puppet:///modules/disable_stock_repos/CentOS-Base.repo.6"
  } else {
    $src = "puppet:///modules/disable_stock_repos/CentOS-Base.repo.7"
  }

  
  file { '/etc/yum.repos.d/CentOS-Base.repo':
    ensure => 'present',
  	source => $src,
  }
}
