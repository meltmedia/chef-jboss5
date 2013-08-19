#
# Author:: Josh Kennedy (<josh@meltmedia.com>)
# Cookbook Name:: jboss
# Attributes:: jboss
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

# General settings
default[:jboss][:version] = "5.0.1.GA"
default[:jboss][:url] = "http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-#{node[:jboss][:version]}/jboss-#{node[:jboss][:version]}.zip"
default[:jboss][:checksum] = "d3274c0c5db33d98a0cdb703d829b833a8c3250e009e5d1843956dd22d182dd8"
default[:jboss][:target_dir] = "/opt"
default[:jboss][:dir] = "#{node[:jboss][:target_dir]}/jboss-#{node[:jboss][:version]}"
default[:jboss][:server_configuration] = "default"
default[:jboss][:server] = "/server/#{node[:jboss][:server_configuration]}"
default[:jboss][:lib] = "#{node[:jboss][:server]}/lib"
default[:jboss][:deploy] = "#{node[:jboss][:server]}/deploy"
default[:jboss][:runlevel] = "80"
default[:jboss][:init_script] = "/etc/init.d/jboss"

# unix service user and group
default[:jboss][:systemuser]="jboss"
default[:jboss][:systemgroup]="jboss"

# Port to listen on for incoming connections
default[:jboss][:bind_address]="0.0.0.0"
default[:jboss][:http_port]="8080"
default[:jboss][:ajp_port]="8009"

default[:jboss][:mysql][:version] = "5.1.20"
default[:jboss][:mysql][:url] = "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-#{node[:jboss][:mysql][:version]}.tar.gz/from/http://mirror.services.wisc.edu/mysql/"
default[:jboss][:mysql][:checksum] = "6f187e86e434f840244a38c3b4dfa55bf67cc75121d72f282edb4a4a7a51db71"

default[:jboss][:oracle][:version] = "11.2.0.3"
default[:jboss][:oracle][:maven_path] = "com/oracle/ojdbc6/#{node[:jboss][:oracle][:version]}/ojdbc6-#{node[:jboss][:oracle][:version]}.jar"
default[:jboss][:oracle][:repo_url] = "http://repo2.maven.org/maven2"
default[:jboss][:oracle][:checksum] = "b7a8656754c891f2d9605afc6d2f4d98a5a8d6fbafe0065b24590061794b1460"


#Mail Service default values
default[:jboss][:mail][:jndi_name]               = "java:/Mail"
default[:jboss][:mail][:username]                = "nobody"
default[:jboss][:mail][:password]                = "password"
default[:jboss][:mail][:mail_store_protocol]     = "pop3"
default[:jboss][:mail][:mail_transport_protocol] = "smtp"
default[:jboss][:mail][:mail_user]               = "nobody"
default[:jboss][:mail][:mail_pop3_host]          = "pop3.nosuchhost.nosuchdomain.com"
default[:jboss][:mail][:mail_smtp_host]          = "smtp.nosuchhost.nosuchdomain.com"
default[:jboss][:mail][:mail_smtp_port]          = 25
default[:jboss][:mail][:mail_from]               = "nobody@nosuchhost.nosuchdomain.com"
default[:jboss][:mail][:mail_debug]              = false

