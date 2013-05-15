# Class: java::params
#
# This class defines default parameters used by the main module class java
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to java class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class java::params {

  ### Application related parameters

  $package_provider = 'openjdk'
  $package_flavor = 'jre'

  $major_version = '7'

  $package = ''

  # Oracle-handling stuff
  # Debian repo via oab-java
  # FIXME!
  $oracle_repo_url = ''
  $oracle_package = ''
  $oracle_destination_dir = '/tmp'
  $oracle_extracted_dir = '/tmp'
  $oracle_postextract_command = $::operatingsystem ? {
    /(?i:RedHat|Centos|Fedora|Scientific|Amazon|Linux)/ => 'rpm -i',
    /(?i:Ubuntu|Debian|Mint)/                           => 'dpkg -i',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/java',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/java/jvm.cfg',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $version = 'present'
  $options = ''
  $absent = false
  $audit_only = false
  $noops = false
}
