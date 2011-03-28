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

# Settings for /etc/hive/conf/hive-site.xml

default[:Hadoop][:Hive][:hiveExecScratchdir] = "/tmp/hive-${user.name}"
default[:Hadoop][:Hive][:hiveMetastoreLocal] = "true"
default[:Hadoop][:Hive][:javaxJdoOptionConnectionURL] = "jdbc:mysql://hivemetadb.example.com:3306/hive?createDatabaseIfNotExist=true"
default[:Hadoop][:Hive][:javaxJdoOptionConnectionDriverName] = "com.mysql.jdbc.Driver"
default[:Hadoop][:Hive][:javaxJdoOptionConnectionUserName] = "hadoop"
default[:Hadoop][:Hive][:javaxJdoOptionConnectionPassword] = "hadoop"
default[:Hadoop][:Hive][:hiveMetastoreWarehouseDir] = "/user/hive/warehouse"
default[:Hadoop][:Hive][:hiveMetastoreConnectRetries] = "5"
default[:Hadoop][:Hive][:hiveMetastoreRawstoreImpl] = "org.apache.hadoop.hive.metastore.ObjectStore"
default[:Hadoop][:Hive][:hiveDefaultFileformat] = "TextFile"
default[:Hadoop][:Hive][:hiveMapAggr] = "false"
default[:Hadoop][:Hive][:hiveJoinEmitInterval] = "1000"
default[:Hadoop][:Hive][:hiveExecScriptMaxerrsize] = "100000"
default[:Hadoop][:Hive][:hiveExecCompressOutput] = "false"
default[:Hadoop][:Hive][:hiveExecCompressIntermediate] = "false"

