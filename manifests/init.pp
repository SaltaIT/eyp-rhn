# == Class: rhn
#
class rhn (
            $username=undef,
            $password=undef,
            $already_registered=false,
            $http_proxy=undef
          ) inherits rhn::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($rhn::params::rhn_needed and $rhn::params::packages!=undef)
  {
    package { $rhn::params::packages:
      ensure => 'installed',
    }

    if(!$already_registered)
    {
      if($username==undef or $password==undef)
      {
        fail("Not already registered: RHN username(${username}) and password(${password}) required")
      }

      exec { 'rhn register':
        command => "rhnreg_ks '--username=${username}' '--password=${password}'",
        unless  => 'rhn_check',
        require => Package[$rhn::params::packages],
      }
    }

    file { '/etc/sysconfig/rhn/up2date':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template("${module_name}/rhn_up2date.erb"),
      require => Package[$rhn::params::packages],
    }
  }
}
