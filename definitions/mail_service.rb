#
# Author:: John McEntire (<john.mcentire@meltmedia.com>)
# Cookbook Name:: jboss
# Definition:: mail_service
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

define :mail_service, 
  :template                => "mail-service.xml.erb", 
  :jndi_name               => "java:/Mail", 
  :username                => "nobody", 
  :password                => "password", 
  :mail_store_protocol     => "pop3",
  :mail_transport_protocol => "smtp",
  :mail_user               => "nobody",
  :mail_pop3_host          => "pop3.nosuchhost.nosuchdomain.com",
  :mail_smtp_host          => "smtp.nosuchhost.nosuchdomain.com",
  :mail_smtp_port          => 25,
  :mail_from               => "nobody@nosuchhost.nosuchdomain.com",
  :mail_debug              => false do

  template "#{node[:jboss][:dir]}/server/#{node[:jboss][:server_configuration]}/deploy/mail-service.xml" do
    source params[:template]
    owner node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
    mode "0640"

    variables(
      :params => params
    )
  end
end
