#
# Author:: Josh Kennedy (<josh@meltmedia.com>)
# Cookbook Name:: jboss
# Recipe:: default
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
include_recipe "java"

# jboss is packaged as a zip
case node['platform']
when "ubuntu","debian","centos","redhat","fedora"
  %w{unzip}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

directory "#{node[:jboss][:dir]}" do
  recursive true
  action :create
end

# Add User and group
group node[:jboss][:systemgroup] do
end

user node[:jboss][:systemuser] do
  comment "JBoss"
  gid node[:jboss][:systemgroup]
  home node[:jboss][:dir]
  shell "/bin/bash"
end

if !File.exists?("#{node[:jboss][:dir]}/JBossORG-EULA.txt")
  remote_file "#{Chef::Config[:file_cache_path]}/jboss-#{node[:jboss][:version]}.zip" do
    checksum node[:jboss][:checksum]
    source node[:jboss][:url]
    mode "0644"

    action :create_if_missing
  end

  execute "unzip-jboss" do
    cwd node[:jboss][:target_dir]
    command "unzip #{Chef::Config[:file_cache_path]}/jboss-#{node[:jboss][:version]}.zip"

    creates "#{node[:jboss][:dir]}/JBossORG-EULA.txt"
  end
end

# Link init script, and add to runlevel
# TODO add additional platforms
case node['platform']
when "ubuntu","debian"
  template "#{node[:jboss][:dir]}/bin/jboss_init_ubuntu.sh" do
    source "jboss_init_ubuntu.sh.erb"
    owner node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
    mode "0755"
  end

  execute "link-jboss-init" do
    command "ln -s #{node[:jboss][:dir]}/bin/jboss_init_ubuntu.sh #{node[:jboss][:init_script]}"
    creates "#{node[:jboss][:init_script]}"
  end
  
  execute "add-jboss-init" do
    command "update-rc.d jboss defaults #{node[:jboss][:runlevel]}"
  end
end

chown "#{node['jboss']['dir']}" do
  user node[:jboss][:systemuser]
  group node[:jboss][:systemgroup]
  notifies :start, "service[jboss]", :delayed
end

service "jboss" do
  supports :start => true, :restart => true, :stop => true
  action :enable
end

log "Server is running at to 'http://#{server_fqdn}:#{node[:jboss][:http_port]}/'" do
  action :nothing
end
