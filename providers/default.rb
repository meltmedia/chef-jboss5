include Chef::Mixin::LanguageIncludeRecipe

action :install do
  include_recipe "jboss::server"
end

action :jboss_start do
  log "starting jboss"
  service "jboss" do
    action :start
    persist false
  end
end

action :jboss_stop do
  log "stopping jboss"
  service "jboss" do
    action :stop
    persist false
  end
end

action :jboss_restart do
  service "jboss" do
    action :restart
    persist false
  end
end
