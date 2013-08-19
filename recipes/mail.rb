#
# Author:: John McEntire (<john.mcentire@meltmedia.com>)
# Cookbook Name:: jboss
# Recipe:: mail
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

# install mail service mbean
mail_service "mail" do
  jndi_name               "#{node[:jboss][:mail][:jndi_name]}"
  username                "#{node[:jboss][:mail][:username]}"
  password                "#{node[:jboss][:mail][:password]}"
  mail_store_protocol     "#{node[:jboss][:mail][:mail_store_protocol]}"
  mail_transport_protocol "#{node[:jboss][:mail][:mail_transport_protocol]}"
  mail_user               "#{node[:jboss][:mail][:mail_user]}"
  mail_pop3_host          "#{node[:jboss][:mail][:mail_pop3_host]}"
  mail_smtp_host          "#{node[:jboss][:mail][:mail_smtp_host]}"
  mail_smtp_port          "#{node[:jboss][:mail][:mail_smtp_port]}"
  mail_from               "#{node[:jboss][:mail][:mail_from]}"
  mail_debug              "#{node[:jboss][:mail][:mail_debug]}"
end

