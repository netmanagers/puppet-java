# = Class: java
#
# This is the main java class
#
#
# == Parameters
#
# [*package_provider*]
#   Which provider of the Java package are we using.
#   Currently available: 'openjdk', 'oracle'
#   If you choose 'oracle', you need to specify the you want to install
#   Default: openjdk
#
# [*package_flavor*]
#   One of 'jdk', 'jre'
#   Default: 'jre'
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, java class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $java_myclass
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $java_absent
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in java::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of java package
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include java"
# - Call java as a parametrized class
#
# See README for details.
#
#
class java (
  $my_class                   = params_lookup( 'my_class' ),
  $major_version              = params_lookup( 'major_version' ),
  $version                    = params_lookup( 'version' ),
  $absent                     = params_lookup( 'absent' ),
  $noops                      = params_lookup( 'noops' ),
  $package                    = params_lookup( 'package' ),
  $package_provider           = params_lookup( 'package_provider' ),
  $package_flavor             = params_lookup( 'package_flavor' ),
  $oracle_repo_url            = params_lookup( 'oracle_repo_url' ),
  $oracle_package             = params_lookup( 'oracle_package' ),
  $oracle_destination_dir     = params_lookup( 'oracle_destination_dir' ),
  $oracle_extracted_dir       = params_lookup( 'oracle_extracted_dir' ),
  $oracle_postextract_command = params_lookup( 'oracle_postextract_command' )
  ) inherits java::params {

  $bool_absent=any2bool($absent)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $java::bool_absent ? {
    true  => 'absent',
    false => $java::version,
  }

  ### Managed resources
  # Java package name changes in sooooo many ways that we're
  # trying to deal with that
 
  if $java::package_provider == 'oracle' {
    puppi::netinstall { 'netinstall_oracle_java':
      url                 => "${java::oracle_repo_url}/${java::oracle_package}",
      destination_dir     => $java::oracle_destination_dir,
      extracted_dir       => $java::oracle_extracted_dir,
      extract_command     => 'rsync',
      postextract_command => $java::oracle_postextract_command,
   }

   $real_package = $java::oracle_package

  } else {
    $real_package = $java::package ? {
      ''       => $java::package_provider ? {
        'openjdk' => $java::package_flavor ? {
          'jdk' => $::operatingsystem ? {
            /(?i:RedHat|Centos|Fedora|Scientific|Amazon|Linux)/ =>
              "java-1.${java::major_version}.0-openjdk-devel",
            /(?i:Ubuntu|Debian|Mint)/                           =>
              "openjdk-${java::major_version}-jdk",
          },
          'jre' => $::operatingsystem ? {
            /(?i:RedHat|Centos|Fedora|Scientific|Amazon|Linux)/ =>
              "java-1.${java::major_version}.0-openjdk",
            /(?i:Ubuntu|Debian|Mint)/                           =>
              "openjdk-${java::major_version}-jre-headless",
          },
        },
        default   => fail("OperatingSystem ${::operatingsystem} not supported"),
      },
      default => $java::package,
    }

    package { $java::real_package:
      ensure  => $java::manage_package,
      noop    => $java::bool_noops,
    }
  }

  ### Include custom class if $my_class is set
  if $java::my_class {
    include $java::my_class
  }

}
