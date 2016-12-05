# == Class: rhn
#
class rhn (
            $username           = undef,
            $password           = undef,
            $already_registered = false,
            $http_proxy         = undef,
            $up2date_replace    = false,
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

      if($rhs::params::subscription_manager)
      {
        # subscription-manager register --username SRLCUK --password d9uAYQSgCX --auto-attach
        exec { 'rhn register':
          command => "subscription-manager register '--username=${username}' '--password=${password}' --auto-attach",
          unless  => 'subscription-manager status',
          require => Package[$rhn::params::packages],
        }

        if versioncmp($::puppetversion, '3.8.0') >= 0
        {
          schedule { 'eyp-rhn daily schedule':
            period => daily,
            repeat => 1,
          }

          Exec['rhn register'] {
            schedule => 'eyp-rhn daily schedule',
          }
        }
      }
      else
      {
        exec { 'rhn register':
          command => "rhnreg_ks '--username=${username}' '--password=${password}'",
          unless  => 'rhn_check',
          require => Package[$rhn::params::packages],
        }

        if versioncmp($::puppetversion, '3.8.0') >= 0
        {
          schedule { 'eyp-rhn daily schedule':
            period => daily,
            repeat => 1,
          }

          Exec['rhn register'] {
            schedule => 'eyp-rhn daily schedule',
          }
        }
      }
    }

    file { '/etc/sysconfig/rhn/up2date':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      replace => $up2date_replace,
      content => template("${module_name}/rhn_up2date.erb"),
      require => Package[$rhn::params::packages],
    }
  }
}
