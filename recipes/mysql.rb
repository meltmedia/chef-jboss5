#
# Author:: Josh Kennedy (<josh@meltmedia.com>)
# Cookbook Name:: jboss
# Recipe:: mysql
#
# Copyright 2011, Meltmedia
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

# x mysql-connector-java-5.1.20/mysql-connector-java-5.1.20-bin.jar

# install mysql connector jar
if !File.exists?("#{node[:jboss][:dir]}/#{node[:jboss][:lib]}/mysql-connector-java-bin.jar")
  remote_file "#{Chef::Config[:file_cache_path]}/mysql-connector-java-#{node[:jboss][:mysql][:version]}.tar.gz" do
    checksum node[:jboss][:mysql][:checksum]
    source node[:jboss][:mysql][:url]
    mode "0644"

    action :create_if_missing
  end

  execute "unzip-connector" do
    cwd "#{Chef::Config[:file_cache_path]}"
    command "tar zxvf mysql-connector-java-#{node[:jboss][:mysql][:version]}.tar.gz"
  end

  execute "move-connector" do
    cwd "#{node[:jboss][:dir]}/#{node[:jboss][:lib]}"
    command "mv #{Chef::Config[:file_cache_path]}/mysql-connector-java-#{node[:jboss][:mysql][:version]}/mysql-connector-java-#{node[:jboss][:mysql][:version]}-bin.jar mysql-connector-java-bin.jar"

    creates "#{node[:jboss][:dir]}/#{node[:jboss][:lib]}/mysql-connector-java-bin.jar"
  end

  chown "#{node['jboss']['dir']}/#{node[:jboss][:lib]}/mysql-connector-java-bin.jar" do
    user node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
  end
end

