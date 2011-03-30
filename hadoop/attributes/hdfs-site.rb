# Copyright 2011, Outbrain, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Settings for /etc/hadoop/conf/hdfs-site.xml
default[:Hadoop][:HDFS][:dfsNameDir] = [ "/data/a/dfs/name", "/data/b/dfs/name" ]
default[:Hadoop][:HDFS][:dfsSecondaryHttpAddress] = "10.0.0.254:50090"
default[:Hadoop][:HDFS][:dfsDatanodeMaxXcievers] = "4096"
default[:Hadoop][:HDFS][:dfsDatanodeDuReserved] = "1073741824"
default[:Hadoop][:HDFS][:dfsDatanodeHandlerCount] = "4"
default[:Hadoop][:HDFS][:dfsNamenodeHandlerCount] = "10"
default[:Hadoop][:HDFS][:dfsPermissions] = "false"
default[:Hadoop][:HDFS][:dfsSupportAppend] = "true"
default[:Hadoop][:HDFS][:dfsHostsExclude] = "/etc/hadoop/conf/dfs.hosts.exclude"


 


