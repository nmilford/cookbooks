# This will install Apache Cassandra and can be used to manage multiple clusters.

# Copyright 2012, Nathan Milford.
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

# To build the databags, first set your EDITOR environment variable. Then paste
# the JSON into the editor knife opens.
#
#   export EDITOR=vim
#   knife data bag create Cassandra cass01
#
# For reference, this is the current Cassandra databag schema:
# {
#   "id": "hostname",
#   "location": "DC:RACK",
#   "initial_token": "",
#   "cluster_name": ""
# }

# Sourcing some initial values fromthe 'Cassandra' databag using the hostname 
# as the key:
Cassandra = data_bag_item('Cassandra', node[:hostname])
node.set[:Cassandra][:initial_token] = Cassandra['initial_token']
node.set[:Cassandra][:cluster_name] = Cassandra['cluster_name']

# Set some cluster-specific attributes. I like to override the defaults here
# per cluster. Jsut add a 'when block' per cluster.
case Cassandra['cluster_name']
when "Prod Cluster"
   node.set[:Cassandra][:Version] = "1.0.7-1"
   node.set[:Cassandra][:seeds] = "192.168.1.1, 192.168.1.2"

   # The nodes on this cluster all have 12 cores, so (8*12 = 96)
   node.set[:Cassandra][:concurrent_writes] = 96

when "Test Cluster"
   node.set[:Cassandra][:Version] = "1.0.7-1"
   node.set[:Cassandra][:seeds] = "10.0.0.1, 10.0.0.2"

   # The nodes on this cluster have less RAM.
   node.set[:Cassandra][:MAX_HEAP_SIZE] = "6G"

end

# I use the PropertyFileSnitch with the NetworTopologyStrategy. Here we can
# use information store in the node's databag to dynamically create the 
# cassandra-topology.properties file for each cluster.
#
# Building an array of nodes in this cluster and building stuff to pass to the
# cassandra-topology.properties template.
#
# We grab the location attribute from the databag and glue it to the node's IP.
#
# In the end the cassandra-topology.properties should be IP=DC:RACK for each node.
 
myCluster = Cassandra['cluster_name']
t = Array.new
search(:Cassandra, "cluster_name:#{myCluster}") do |n|

   id = n['id']
   loc = n['location']

   # The id of the databag item is just the hostname of the host, so I can glue
   # the id to my company's domain name and get the host's chef node name.

   dom = ".yourcompany.com"

   # In my production environment I have a sub domain per datacenter and I have
   # NY1 and LA1 datacenters defined in the databag's location for the node.
   # This is some exmaple code to build the domain from hints in your databag
   #
   #   if loc.include?('NY')
   #     dom = ".ny1.yourcompany.com"
   #   elsif loc.include?('LA')
   #     dom = ".la1.yourcompany.com"
   #   end

   # Get the node.
   target = search(:node, "name:#{id + dom}")

   # Grab it's IP address.
   addr = target[0]['ipaddress']

   # Add it to the toplology array.
   t << addr + "=" + loc

end


# Drop the yum repo.
cookbook_file "/etc/yum.repos.d/riptano.repo" do
  owner "root"
  group "root"
  mode "0644"
  source "riptano.repo"
end

# Install the package.
package "apache-cassandra1" do
  action :install
  version node[:Cassandra][:Version]
end

# Drop the JNA Jar.
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

# Drop MX4J jar.
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

# Setup cassandra.
node[:Cassandra][:data_file_directories].each do |dataDir|
  directory dataDir do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
    action :create
  end
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

# Deifne cassandra as a service.
service "cassandra" do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
end

# Drop the config.
template "/etc/cassandra/conf/cassandra-env.sh" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-env.sh.erb"
end

template "/etc/cassandra/conf/cassandra-topology.properties" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-topology.properties.erb"
  # Pass the topology array as 't' to the template.
  variables(
    :t => t
  )
end

template "/etc/cassandra/conf/cassandra.yaml" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra.yaml.erb"
end
