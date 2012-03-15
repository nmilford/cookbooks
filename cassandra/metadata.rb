maintainer       "Nathan Milford"
maintainer_email "nathan@milford.io"
license          "All rights reserved"
description      "Installs/Configures multiple Apache Cassandra clusters"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.7"
recipe           "cassandra::default", "Installs/confures Apache Cassandra."
