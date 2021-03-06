class sun-jdk::debian
{

  $pressed_filename = "sun-jdk6.pressed"
  $pressed_dir = "/var/cache/debconf/"
  $pressed_file = "${pressed_dir}/${pressed_filename}"
  $package_name = "sun-java6-jdk"

  file { "$pressed_file":
    source => "puppet:///modules/sun-jdk/dpkg/$pressed_filename",
    ensure => present
  }

  package { "$package_name":
    ensure       => latest,
    responsefile => "$pressed_file",
    require      => File["$pressed_file"]
  }

  package { "java-common":
    ensure  => latest,
    require => Package["$package_name"],
    notify  => Exec['update-java-alternatives-sun-jdk-6'];
  }

  exec { 'update-java-alternatives-sun-jdk-6':
    command     => 'update-java-alternatives --jre --set java-6-sun',
    path        => '/sbin:/bin:/usr/sbin:/usr/bin',
    refreshonly => true,
    require     => Package["java-common"];
  }
}
