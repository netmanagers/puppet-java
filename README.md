# Puppet module: java

## [Maintainer wanted](https://github.com/netmanagers/puppet-java/issues/new)

**WARNING WARNING WARNING**

[puppet-java](https://github.com/netmanagers/puppet-java) is not currently being maintained, 
and may have unresolved issues or not be up-to-date. 

I'm still using it on a daily basis (with Puppet 3.8.5) and fixing issues I find
while using it. But sadly, I don't have the time required to actively add new features,
fix issues other people report or port it to Puppet 4.x.

If you would like to maintain this module,
please create an issue at: https://github.com/netmanagers/puppet-java/issues
offering yourself.

## Getting started

This is a Puppet module for java
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-java

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install java with default settings

        class { 'java': }

* Install a specific version of java package

        class { 'java':
          version => '1.0.1',
        }

* Remove java resources

        class { 'java':
          absent => true
        }

* Enable auditing without without making changes on existing java configuration *files*

        class { 'java':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'java':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'java':
          source => [ "puppet:///modules/example42/java/java.conf-${hostname}" , "puppet:///modules/example42/java/java.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'java':
          source_dir       => 'puppet:///modules/example42/java/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'java':
          template => 'example42/java/java.conf.erb',
        }

* Automatically include a custom subclass

        class { 'java':
          my_class => 'example42::my_java',
        }



## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-java.png?branch=master)](https://travis-ci.org/netmanagers/puppet-java)
