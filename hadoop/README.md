Hadoop Cookbook
===============

Builds a working Hadoop cluster from bare metal.

This is my first Chef recipe and on top of that it is a first pass.  

I hope it is helpful and please improve where you see fit.

I tried to put all of the config file knobs I adjust on the cluster in the attributes so I could change them per node.

I have some really ugly code to build disks and enumerate target directories for `dfs.name.dir`, `dfs.data.dir` and `mapred.local.dir`.

For how I am building disks, see: `files/default/buildHadoopDisks.sh`

Requirements
============

Built & tested for a CentOS 5.5 environment.  Results may vary elsewhere.

This cookbook assumed that java has already been installed. We use our own proprietary cookbook for that. 

Consider adding a line to the `metadata.rb` for this cookbook:

    depends 'java-cookbook'

ATTRIBUTES
==========

See the attributes directory.  All of the basic settings you might use to tweak your hadoop cluster are avaliable there.

To start you'll want to adjust

* attributes/core-site.rb: default[:Hadoop][:Core][:fsDefaultName]

* attributes/hadoop-env.rb default[:Hadoop][:Env][:HADOOP_HEAPSIZE]

* attributes/hdfs-site.rb default[:Hadoop][:HDFS][:dfsSecondaryHttpAddress]

* attributes/mapred-site.rb default[:Hadoop][:Mapred][:mapredJobTracker]


USAGE
=====

Add the default recipe to any host you only want hadoop libs and config on.

Add any other if you want a node to have a specific function.

TODO
====

* Find out what chef best practices I am badly breaking and address them.

* Make the config template/attribute setup more modular.

* Thoroughly clean up the mysql metastore recipe.

* Make multiple mysql metastore slaves replicating down stream from the primary
  to create redundancy.

* Clean up the dfs.name.dir/dfs.data.dir/mapred.local.dir enumeration code.

* Have NameNode automatically mount NFS shares from other nodes and add them 
  to dfs.name.dir

* Have the NameNode safely format if this is a first time deploy and ignore otherwise.

* Deploy NameNode backup scripts.

* Deploy Hive metastore backup scripts.

* Balancer setup.

* Oozie recipe.

* Pig recipe.

* Hue recipe.

* Add array to populate dfs.hosts.exclude file.

LICENSE & AUTHOR
================

Author: Nathan Milford <nathan@outbrain.com>

Copyright: &copy; 2011, Outbrain, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
