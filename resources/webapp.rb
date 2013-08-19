actions :deploy, :undeploy

def initialize(*args)
  super
  @action = :deploy
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :uri, :kind_of => String
