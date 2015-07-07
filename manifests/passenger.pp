# Class: puppetdashboard::passenger
#
# This class configures parameters for the puppetdashboard module.
#
# Parameters:
#   [*passenger_install*]
#     - Install passenger using puppetlabs/passenger module or assume it is
#       installed by 3rd party
#
#   [*dashboard_site*]
#     - The ServerName setting for Apache
#
#   [*dashboard_port*]
#     - The port on which puppetdashboard should run
#
#   [*dashboard_config*]
#     - The Dashboard configuration file
#
#   [*dashboard_root*]
#     - The path to the Puppet Dashboard library
#
#   [*rails_base_uri*]
#     - The base URI for the application
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetdashboard::passenger (
  $passenger_install = true,
  $dashboard_site,
  $dashboard_port,
  $dashboard_root,
  $rails_base_uri,
) inherits puppetdashboard {

  file { '/etc/init.d/puppet-dashboard':
    ensure => absent,
  }

  case $::puppetdashboard::passenger_type {
    apache: {
      include apache::passenger
    }
    nginx: { }
    default: { }
  }

  case $::puppetdashboard::passenger_type {
    apache: {
      apache::vhost { $dashboard_site:
        port     => $dashboard_port,
        priority => $vhost_priority,
        docroot  => "${dashboard_root}/public",
        template => $::puppetdashboard::real_template_passenger,
      }
    }
    nginx: {
      nginx::vhost { $dashboard_site:
        port           => $dashboard_port,
        priority       => $vhost_priority,
        docroot        => "${dashboard_root}/public",
        create_docroot => false,
        template       => $::puppetdashboard::real_template_passenger,
      }
    }
    default: { }
  }
}
