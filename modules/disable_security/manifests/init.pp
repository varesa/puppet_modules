class disable_security {
  
    service { 
      "firewalld":
        ensure   => 'stopped',
        enable   => 'false',
    }

    class { 
      'selinux':
        mode => "permissive"
    }
}
