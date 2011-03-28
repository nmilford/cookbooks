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

# Install the slave processes.
package "hadoop-0.20-datanode" do
  action :install
  version node[:Hadoop][:Version]
end

package "hadoop-0.20-tasktracker" do
  action :install
  version node[:Hadoop][:Version]
end

cookbook_file "/tmp/buildHadoopDisks.sh" do
  source "buildHadoopDisks.sh"
  owner "root"
  group "root"
  backup false
  mode "0755"
end

execute "buildHadoopDisks" do
  command "/tmp/buildHadoopDisks.sh"
  action :run
end

# Oh, please god no!  I'll make this more elegent later...
if File.exist?("/data/f")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data", "/data/b/dfs/data", "/data/c/dfs/data", "/data/d/dfs/data", "/data/e/dfs/data", "/data/f/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local", "/data/e/mapred/local", "/data/f/mapred/local" ]
elsif File.exist?("/data/e")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data", "/data/b/dfs/data", "/data/c/dfs/data", "/data/d/dfs/data", "/data/e/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local", "/data/e/mapred/local" ]
elsif File.exist?("/data/d")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data", "/data/b/dfs/data", "/data/c/dfs/data", "/data/d/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local" ]
elsif File.exist?("/data/c")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data", "/data/b/dfs/data", "/data/c/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local" ]
elsif File.exist?("/data/b")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data", "/data/b/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local" ]
elsif File.exist?("/data/a")
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local" ]
else
   node.set['Hadoop']['HDFS']['dfsDataDir'] = [ "/data/a/dfs/data" ]
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local" ]
end

node[:Hadoop][:HDFS][:dfsDataDir].each do |dataDir|
  directory dataDir do
    owner "hdfs"
    group "hadoop"
    mode "0755"
    recursive true
    action :create
  end
end

node[:Hadoop][:Mapred][:mapredLocalDir].each do |localDir|
  directory localDir do
    owner "mapred"
    group "hadoop"
    mode "0755"
    recursive true
    action :create
  end
end

service "hadoop-0.20-datanode" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end

service "hadoop-0.20-tasktracker" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end
