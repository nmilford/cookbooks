maintainer       "Outbrain, Inc."
maintainer_email "nathan@outbrain.com"
license          "All rights reserved"
description      "Installs/Configures cassandra"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"
recipe           "cassandra::default", "Installs Cassandra."
