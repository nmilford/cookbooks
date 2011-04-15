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

cookbook_file "/etc/yum.repos.d/riptano.repo" do
  owner "root"
  group "root"
  mode "0644"
  source "riptano.repo"
end

package "apache-cassandra" do
  action :install
  version node[:Cassandra][:Version]
end

bash "installJNA" do
user "root"
  cwd "/tmp"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/jna.jar ]; then
    wget http://java.net/projects/jna/sources/svn/content/trunk/jnalib/dist/jna.jar?rev=1193 -O /usr/share/cassandra/lib/jna.jar
    chown cassandra /usr/share/cassandra/lib/jna.jar
    chmod 755 /usr/share/cassandra/lib/jna.jar
  fi
  EOH
end

bash "installMX4J" do
user "root"
  cwd "/tmp"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/mx4j-tools.jar ]; then
    wget http://sourceforge.net/projects/mx4j/files/MX4J%20Binary/3.0.2/mx4j-3.0.2.tar.gz/download
    tar zxvf mx4j-3.0.2.tar.gz mx4j-3.0.2/lib/mx4j-tools.jar
    cp mx4j-3.0.2/lib/mx4j-tools.jar /usr/share/cassandra/lib/
    chown cassandra:cassandra /usr/share/cassandra/lib/mx4j-tools.jar
    chmod 755 /usr/share/cassandra/lib/mx4j-tools.jar
  fi
  EOH
end

cookbook_file "/tmp/buildCassandraDisk.sh" do
  source "buildCassandraDisk.sh"
  owner "root"
  group "root"
  backup false
  mode "0755"
end

execute "buildCassandraDisk" do
  command "/tmp/buildCassandraDisk.sh"
  action :run
end

if File.exist?("/data/f")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/", "/data/b/", "/data/c/", "/data/d/", "/data/e/", "/data/f/" ]
elsif File.exist?("/data/e")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/", "/data/b/", "/data/c/", "/data/d/", "/data/e/" ]
elsif File.exist?("/data/d")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/", "/data/b/", "/data/c/", "/data/d/" ]
elsif File.exist?("/data/c")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/", "/data/b/", "/data/c/" ]
elsif File.exist?("/data/b")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/", "/data/b/" ]
elsif File.exist?("/data/a")
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/" ]
else
   node.set['Cassandra']['data_file_directories'] = [ "/data/a/" ]
end

node[:Cassandra][:data_file_directories].each do |dataDir|
  directory dataDir do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
    action :create
  end
end


service "cassandra" do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
end

template "/etc/cassandra/conf/cassandra-env.sh" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-env.sh.erb"
  notifies :restart, resources(:service => "cassandra")
end

template "/etc/cassandra/conf/cassandra-topology.properties" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-topology.properties.erb"
  notifies :restart, resources(:service => "cassandra")
end

template "/etc/cassandra/conf/cassandra.yaml" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra.yaml.erb"
  notifies :restart, resources(:service => "cassandra")
end


directory node[:Cassandra][:commitlog_directory] do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

directory node[:Cassandra][:saved_caches_directory] do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

