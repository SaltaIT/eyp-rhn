define rhn::addrepo (
                      $reponame=$name
                    ) {

  # subscription-manager repos --enable=rhel-7-server-supplementary-rpms
  # subscription-manager repos --enable=rhel-7-server-optional-rpms

  exec{ "subscribe repo ${reponame}":
    command => "subscription-manager repos --enable=${reponame}",
    unless  => "subscription-manager repos | grep \"Repo ID\" | grep ${reponame}",
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
