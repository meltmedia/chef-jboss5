#
# Author:: Josh Kennedy (<josh@meltmedia.com>)
# Cookbook Name:: jboss
# Definition:: chown
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

define :chown, :user => "root", :group => "root" do
  execute "chown" do
    command "chown -R #{params[:user]}:#{params[:group]} #{params[:name]}"
    action :run
  end
end
