action :deploy do
  name = new_resource.name
  path = new_resource.path
  uri = new_resource.uri

  new_resource.updated_by_last_action(false)

  if !path.nil?
    # Move local file
    webapp_file = execute "move-file" do
      command "mv #{path} #{node[:jboss][:dir]}#{node[:jboss][:deploy]}/#{name}"
      
      action :nothing
      
      creates "#{node[:jboss][:dir]}#{node[:jboss][:deploy]}/#{name}"
    end

    webapp_file.run_action(:run)

    if webapp_file.updated_by_last_action?
      new_resource.updated_by_last_action(true)
    end
  elsif !uri.nil?
    # download file
    webapp_file = remote_file "#{node[:jboss][:dir]}#{node[:jboss][:deploy]}/#{name}" do
      source uri
      
      owner node[:jboss][:systemuser]
      group node[:jboss][:systemgroup]
      mode 0644

      action :nothing
    end

    webapp_file.run_action(:create_if_missing)

    if webapp_file.updated_by_last_action?
      new_resource.updated_by_last_action(true)
    end
  else
    raise "Must specify either a path, or a URI to deploy"
  end

  if new_resource.updated_by_last_action?
    chown "#{node['jboss']['dir']}" do
      user node[:jboss][:systemuser]
      group node[:jboss][:systemgroup]
    end
  end
end

action :undeploy do
  new_resource.updated_by_last_action(false)

  webapp_file = file "#{node[:jboss][:dir]}#{node[:jboss][:deploy]}/#{new_resource.name}" do
    action :nothing
  end

  webapp_file.run_action(:delete)

  if webapp_file.updated_by_last_action?
    new_resource.updated_by_last_action(true)
  end
end
