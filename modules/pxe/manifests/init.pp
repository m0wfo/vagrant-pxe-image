class pxe {

  package { "dnsmasq":
    ensure => "installed"
  }
  ->
  file { ["/tftpboot", "/tftpboot/boot", "/tftpboot/boot/grub", "/tftpboot/platform"]:
    ensure => "directory",
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }
  -> file { "/tftpboot/boot/grub/menu.lst":
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => template("pxe/menu.lst")
  }
  -> file { "/etc/dnsmasq.conf":
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode  => '0644',
    content => template("pxe/dnsmasq.conf")
  }
}
