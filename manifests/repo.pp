define rhn::repo(
                  $reponame = $name,
                  $ensure   = 'present',
                ) {

  # subscription-manager repos --enable=rhel-7-server-supplementary-rpms
  # subscription-manager repos --enable=rhel-7-server-optional-rpms

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  case $ensure
  {
    'present':
    {
      exec { "subscribe repo ${reponame}":
        command => "subscription-manager repos --enable=${reponame}",
        unless  => "subscription-manager repos --list-enabled | grep \"Repo ID\" | grep ${reponame}",
      }
    }
    'absent':
    {
      exec { "subscribe repo ${reponame}":
        command => "subscription-manager repos --disable=${reponame}",
        unless  => "subscription-manager repos --list-disabled | grep \"Repo ID\" | grep ${reponame}",
      }
    }
    default:
    {
      fail("unsupported mode: ensure=${ensure}")
    }
  }

  if versioncmp($::puppetversion, '3.8.0') >= 0
  {
    if(defined(Schedule['eyp-rhn daily schedule']))
    {
      Exec["subscribe repo ${reponame}"] {
        schedule => 'eyp-rhn daily schedule',
      }
    }
  }
}
