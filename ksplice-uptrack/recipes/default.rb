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

cookbook_file "/etc/yum.repos.d/ksplice-uptrack.repo" do
  source "ksplice-uptrack.repo"
  mode 0644
  owner "root"
  group "root"
end

package "uptrack" do
  action :install
  version node[:uptrack][:version]
end

template "/etc/uptrack/uptrack.conf" do
  source "uptrack.conf.erb"
  mode 0640
  owner "root"
  group "adm"
end

execute "uptrack-upgrade" do
  command "/usr/sbin/uptrack-upgrade -y ; true"
  action :run
end


