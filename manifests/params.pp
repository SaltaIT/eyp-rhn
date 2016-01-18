class rhn::params {

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystem
      {
        'RedHat':
        {
          $packages= [ 'rhn-setup', 'rhn-check' ]
        }
        default:
        {
          notify{ 'rhn':
              message => "Nothing to to here -_-",
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
