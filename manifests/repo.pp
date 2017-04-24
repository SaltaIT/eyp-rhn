define rhn::repo(
                  $reponame = $name,
                  $ensure   = 'present',
                ) {

  include ::rhn
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
        unless  => "bash -c 'yum repolist 2>/dev/null | grep \"^${reponame}\\b\"'",
        #unless  => "subscription-manager repos --list-enabled | grep \"Repo ID\" | grep \"\\b${reponame}\\b\"",
      }
    }
    'absent':
    {
      exec { "subscribe repo ${reponame}":
        command => "subscription-manager repos --disable=${reponame}",
        unless  => "bash -c '! yum repolist 2>/dev/null | grep \"^${reponame}\\b\" > /dev/null'",
        #unless  => "subscription-manager repos --list-disabled | grep \"Repo ID\" | grep \"\\b${reponame}\\b\"",
      }
    }
    default:
    {
      fail("unsupported mode: ensure=${ensure}")
    }
  }
}
