class pxe {

  service { "dnsmasq":
    ensure  => "running",
    enable  => "true",
    require => Package["dnsmasq"]
  }

  service { "nginx":
    ensure  => "running",
    enable  => "true",
    require => Package["nginx"]
  }

  package { "ipxe":
    ensure => "installed"
  }

  package { "nginx":
    ensure => "installed"
  }

  package { "dnsmasq":
    ensure => "installed"
  }

  file { ["/tftpboot"]:
    ensure => "directory",
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }
  ->
  exec { "copy ipxe":
    command => "/bin/cp /usr/lib/ipxe/undionly.kpxe /tftpboot/",
    creates => "/tftpboot/undionly.kpxe"
  }
  -> file { "/etc/dnsmasq.conf":
    require => Package["dnsmasq"],
    notify => Service["dnsmasq"],
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => template("pxe/dnsmasq.conf")
  }
  ->
  file { "/usr/share/nginx/www/bootstrap.ipxe":
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => template("pxe/bootstrap.ipxe")
  }
}
