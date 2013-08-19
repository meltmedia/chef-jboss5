#
# Author:: John McEntire (<john.mcentire@meltmedia.com>)
# Cookbook Name:: jboss
# Recipe:: oracle
#
# Copyright 2012, Meltmedia
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
#

# install oracle jdbc jar
if !File.exists?("#{node[:jboss][:dir]}/#{node[:jboss][:lib]}/ojdbc6.jar")

  remote_file "#{node[:jboss][:dir]}/#{node[:jboss][:lib]}/ojdbc6.jar" do
    checksum node[:jboss][:oracle][:checksum]
    source "#{node[:jboss][:oracle][:repo_url]}/#{node[:jboss][:oracle][:maven_path]}"
    mode "0644"

    action :create_if_missing
  end

  chown "#{node['jboss']['dir']}/#{node[:jboss][:lib]}/ojdbc6.jar" do
    user node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
  end

end

