# Copyright 2011, Nathan Milford
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

#Exit the recipe if system's manufacturer as detected by ohai does not match "Dell"
if !node[:dmi][:system][:manufacturer].include? 'Dell' then
	return
end
execute "setupDellRepo" do
  command "wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash"
  creates "/etc/yum.repos.d/dell-omsa-repository.repo"
  action :run
end

%w{srvadmin-all dell_ft_install}.each do |dellpkg|
   package dellpkg
end

execute "enableSrvAdmin" do
  command "/opt/dell/srvadmin/sbin/srvadmin-services.sh enable"
  action :run
end

execute "startSrvAdmin" do
  command "/opt/dell/srvadmin/sbin/srvadmin-services.sh start ; true"
  action :run
end
