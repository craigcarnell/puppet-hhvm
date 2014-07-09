#
# This module manages hhvm packages.
class hhvm::install::package {

  case $operatingsystem {
    debian,ubuntu: {
      include hhvm::install::prerequisites
          
      if($hhvm::compile_from_source) {
        file { "/usr/local/src/hiphop-php":
	       ensure => "directory",
        }
	          
        vcsrepo { "/usr/local/src/hiphop-php/hhvm":
          ensure   => present,
          provider => git,
				  source   => "git://github.com/facebook/hhvm.git",
				  revision => "master",
				  require  => File["/usr/local/src/hiphop-php"]
        }
			} else {
			  # TODO support package install
			  #wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
        #echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list
        #sudo apt-get update
        #sudo apt-get install hhvm
			}   
    }
    centos,fedora,rhel: {
      fail("Module ${module_name} has no config for ${::operatingsystem}")
    }
  }
  
  # at the moment hiphop does not load php.ini/server.ini by default and we need these for running hhvm from bash
  file { '/usr/local/bin/hhvm-cli':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/usr/local/bin/hhvm-cli.erb"),
  }
}