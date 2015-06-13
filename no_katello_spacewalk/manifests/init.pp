class no_katello_spacewalk {

    exec { "subscription-manager (katello)":
	    command => "/usr/bin/yum remove -y subscription-manager",
	    onlyif => "/bin/rpm -qa | grep subscription-manager"
    }
    
    exec { "spacewalk":
	    command => "/usr/bin/yum remove -y spacewalk*",
	    onlyif => "/bin/rpm -qa | grep spacewalk",
    }
    
}
