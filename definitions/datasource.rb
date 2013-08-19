#
# Author:: Josh Kennedy (<josh@meltmedia.com>)
# Cookbook Name:: jboss
# Definition:: datasource
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

define :datasource, :template => "datasource.xml.erb", :min_pool_size => 5, :max_pool_size => 20, :idle_timeout_minutes => 5, :connection_check => "SELECT 1 FROM dual", :driver_class => "com.mysql.jdbc.Driver", :connection_url => "jdbc:mysql://localhost:3306/jboss", :username => "jboss", :password => "jboss" do
  application_name = params[:name]
  jndi_name = "/#{params[:name]}"

  template "#{node[:jboss][:dir]}#{node[:jboss][:deploy]}/#{application_name}-ds.xml" do
    cookbook "jboss"
    source params[:template]
    owner node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
    mode "0640"

    variables(
      :application_name => application_name,
      :jndi_name => jndi_name,
      :params => params
    )
  end
end
