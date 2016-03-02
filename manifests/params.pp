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
            }
            default: { $rhn_needed=false  }
          }
        }
        default:
        {
          $rhn_needed=false
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
