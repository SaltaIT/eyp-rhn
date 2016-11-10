class rhn::params {

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystem
      {
        'RedHat':
        {
          case $::operatingsystemrelease
          {
            /^6.*/:
            {
              $rhn_needed=true
              $packages= [ 'rhn-setup', 'rhn-check' ]
              $subscription_manager=false
            }
            /^7.*/:
            {
              $rhn_needed=true
              $packages= [ 'rhn-setup', 'rhn-check' ]
              $subscription_manager=true
            }
            default:
            {
              $rhn_needed=false
              $packages=undef
            }
          }
        }
        default:
        {
          $rhn_needed=false
          $packages=undef
          notify{ 'rhn':
              message => 'Nothing to to here -_-',
          }
        }
      }
    }
    'Debian':
    {
      fail('Nothing to to here')
    }
    default: { fail('Nothing to to here')  }
  }
}
