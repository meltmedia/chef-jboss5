actions :install, :uninstall, :clone, :register_service

def initialize(*args)
  super
  @action = :install
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :uri, :kind_of => String
attribute :config, :kind_of => String
attribute :configCookbook, :kind_of => String