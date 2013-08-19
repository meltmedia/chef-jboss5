action :install do
  name = new_resource.name
  path = ""
  uri = new_resource.uri

  new_resource.updated_by_last_action(false)

  if !new_resource.path.nil?
    # Path will be to a zip file that includes the server configuration folder
    path = new_resource.path
  elsif !uri.nil?
    # download file and extract
    server_file = remote_file "#{Chef::Config[:file_cache_path]}/jboss-server-#{name}.zip" do
      source uri
      mode 0644

      action :nothing
    end

    server_file.run_action(:create_if_missing)

    if server_file.updated_by_last_action?
      new_resource.updated_by_last_action(true)
    end

    path = "#{Chef::Config[:file_cache_path]}/jboss-server-#{name}.zip"
  else
    raise "Must specify either a path, or a URI to deploy"
  end

  # Create server folder if missing
  server_configuration_directory = directory "#{node[:jboss][:dir]}/server" do
    owner node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
    mode "0755"

    recursive true
    action :nothing
  end

  server_dir = execute "extract-server" do
    cwd "#{node[:jboss][:dir]}/server/"
    command "unzip #{path}"
    
    action :nothing
    
    creates "#{node[:jboss][:dir]}/server/#{name}"
  end

  server_configuration_directory.run_action(:create)
  server_dir.run_action(:run)

  if server_dir.updated_by_last_action?
    new_resource.updated_by_last_action(true)

    # Chown server configuration
    chown "#{node['jboss']['dir']}" do
      user node[:jboss][:systemuser]
      group node[:jboss][:systemgroup]
    end
  end
end

action :uninstall do
  new_resource.updated_by_last_action(false)

  server_dir = directory "#{node[:jboss][:dir]}/server/#{new_resource.name}" do
    recursive true
    action :nothing
  end

  server_dir.run_action(:delete)

  if server_dir.updated_by_last_action?
    new_resource.updated_by_last_action(true)
  end
end

action :clone do
  new_resource.updated_by_last_action(false)
  name = new_resource.name
  existingServer = new_resource.path
  config = new_resource.config
  configCookbook = "jboss"

  if !new_resource.configCookbook.nil?
    configCookbook = new_resource.configCookbook
  end

  if !Dir.exists?("#{node[:jboss][:dir]}/server/#{existingServer}")
    raise "Server to clone does not exist. #{node[:jboss][:dir]}/server/#{existingServer}"
  end

  if !Dir.exists?("#{node[:jboss][:dir]}/server/#{name}")
    execute "copy-server" do
      cwd "#{node[:jboss][:dir]}/server"
      command "cp -r #{existingServer} #{name}"

      creates "#{node[:jboss][:dir]}/server/#{name}"
    end

    chown "#{node[:jboss][:dir]}/server/#{name}" do
      user node[:jboss][:systemuser]
      group node[:jboss][:systemgroup]   
    end

    if !config.nil?
      cookbook_file "#{node[:jboss][:dir]}/server/#{name}/run.conf" do
        group node[:jboss][:systemgroup]
        user node[:jboss][:systemuser]
        source "#{config}"
        cookbook "#{configCookbook}"
        mode "0644"
      end
    end  
    new_resource.updated_by_last_action(true) 
  end
end

action :register_service do
  new_resource.updated_by_last_action(false)
  name = new_resource.name

  template "#{node[:jboss][:dir]}/bin/jboss-#{name}-init.sh" do
    cookbook "jboss"
    source "jboss_init.sh.erb"
    owner node[:jboss][:systemuser]
    group node[:jboss][:systemgroup]
    mode "0755"

    variables(
      :serverName => name
    )

    action :create_if_missing
  end

  execute "link-jboss-init" do
    command "ln -s #{node[:jboss][:dir]}/bin/jboss-#{name}-init.sh #{node[:jboss][:init_script]}-#{name}"
    creates "#{node[:jboss][:init_script]}-#{name}"
  end

  execute "add-jboss-init" do
    command "update-rc.d jboss-#{name} defaults #{node[:jboss][:runlevel]}"
    notifies :start, "service[jboss-#{name}]", :delayed
  end

  service "jboss-#{name}" do
    supports :start => true, :restart => true, :stop => true
    start_command "service jboss-#{name} start"
    stop_command "service jboss-#{name} stop"
    restart_command "service jboss-#{name} restart"
    action :enable
  end
  new_resource.updated_by_last_action(true)
end

