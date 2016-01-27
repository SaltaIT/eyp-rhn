# == Class: rhn
#
# Full description of class rhn here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'rhn':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class rhn (
            $username,
            $password,
            $already_registered=false,
            $http_proxy=undef
          ) inherits rhn::params {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if(!$rhn::params::rhn_needed)
  {
    package { $rhn::params::packages:
      ensure => 'installed',
    }

    if(!$already_registered)
    {
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
