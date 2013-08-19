#
# Cookbook Name:: jboss
# Recipe:: jboss-base
#
# Copyright 2013, Meltmedia
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

include_recipe "java"

case node['platform']
when "ubuntu","debian","centos","redhat","fedora"
  %w{"unzip"}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

link "/usr/lib/jvm/java-6-openjdk" do
  to "/usr/lib/jvm/java-6-openjdk-amd64"
  link_type :symbolic
end

directory "#{node[:jboss][:dir]}" do
  recursive true
  action :create
end

group "#{node[:jboss][:systemgroup]}" do
end

user "#{node[:jboss][:systemuser]}" do
  comment "JBoss"
  gid node[:jboss][:systemgroup]
  home node[:jboss][:dir]
  shell "/bin/bash"
end

if !File.exists?("#{node[:jboss][:dir]}/JBossORG-EULA.txt")
  remote_file "#{Chef::Config[:file_cache_path]}/jboss-#{node[:jboss][:version]}" do
    checksum node[:jboss][:checksum]
    source node[:jboss][:url]
    mode "0755"

    action :create_if_missing
  end

  execute "unzip-jboss" do
    cwd node[:jboss][:target_dir]
    command "unzip #{Chef::Config[:file_cache_path]}/jboss-#{node[:jboss][:version]}"

    creates "#{node[:jboss][:dir]}/JBossORG-EULA.txt"
  end
end

chown "#{node['jboss']['dir']}" do
  user node[:jboss][:systemuser]
  group node[:jboss][:systemgroup]
end
