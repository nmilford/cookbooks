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

directory "/var/lib/hadoop-0.20/dfs/namesecondary/" do
  owner "hdfs"
  group "hadoop"
  mode "0755"
  recursive true
  action :create
end

package "hadoop-0.20-secondarynamenode" do
  action :install
  version node[:Hadoop][:Version]
end

if File.exist?("/data/a")
   node.node[:Hadoop][:HDFS][:fsCheckpointDir] = "/data/a/dfs/namesecondary"
end

node[:Hadoop][:HDFS][:fsCheckpointDir].each do |checkpointDir|
  directory checkpointDir do
    owner "hdfs"
    group "hadoop"
    mode "0755"
    recursive true
    action :create
  end
end

service "hadoop-0.20-secondarynamenode" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end



