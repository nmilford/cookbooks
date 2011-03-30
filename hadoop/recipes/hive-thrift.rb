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

# We don't need to install the standalone hive recipe.  Here we deploy Hive
# then the scripts to daemonize hive's thrift server.

package "hadoop-hive" do
  action :install
  version node[:Hive][:Version]
end

template "/etc/hive/conf/hive-site.xml" do
  owner "root"
  group "hadoop"
  mode "0644"
  source "hive-site.xml.erb"
end

cookbook_file "/etc/init.d/hive-thrift" do
  owner "root"
  group "root"
  mode "0755"
  source "hive-thrift"
end


bash "prepThriftInit" do
user "root"
  code <<-EOH
  touch /var/run/hive-thrift.pid
  touch /var/log/hive-thrift.log
  touch /var/run/hive-thrift-java.pid
  chown hdfs:hadoop /var/run/hive-thrift.pid 
  chown hdfs:hadoop /var/log/hive-thrift.log
  chown hdfs:hadoop /var/run/hive-thrift-java.pid
  chkconfig --add hive-thrift
  chkconfig hive-thrift
  EOH
end


# Installs the MySQL Java driver so Hive can talk to the MySQL-backed metastore.
bash "getMysqlConnectorJ" do
user "root"
  cwd "/tmp"
  code <<-EOH
  curl http://mysql.he.net/Downloads/Connector-J/mysql-connector-java-5.1.10.tar.gz | tar zxv mysql-connector-java-5.1.10/mysql-connector-java-5.1.10-bin.jar
  cp mysql-connector-java-5.1.10/mysql-connector-java-5.1.10-bin.jar /usr/lib/hive/lib/
  EOH
end

directory "/var/lib/hadoop-0.20/cache/hdfs" do
  owner "hdfs"
  group "hadoop"
  mode "0755"
  recursive true
  action :create
end

service "hive-thrift" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end


