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

package "hadoop-0.20-jobtracker" do
  action :install
  version node[:Hadoop][:Version]
end

template "/etc/hadoop/conf/fair-scheduler.xml" do
  owner "root"
  group "hadoop"
  mode "0644"
  source "fair-scheduler.xml.erb"
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

# Please look away.  I can't believe I published this :/
if File.exist?("/data/f")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local", "/data/e/mapred/local", "/data/f/mapred/local" ]
elsif File.exist?("/data/e")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local", "/data/e/mapred/local" ]
elsif File.exist?("/data/d")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local", "/data/d/mapred/local" ]
elsif File.exist?("/data/c")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local", "/data/c/mapred/local" ]
elsif File.exist?("/data/b")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local", "/data/b/mapred/local" ]
elsif File.exist?("/data/a")
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local" ]
else
   node.set['Hadoop']['Mapred']['mapredLocalDir'] = [ "/data/a/mapred/local" ]
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

service "hadoop-0.20-jobtracker" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end


