Description
===========

This cookbook includes recipes to install jboss. It also
includes a LWRP for managing web applications as well as 
definitions for deploying data sources.

Recipes
=======

default
-------


apache2
---------


mysql
-------------
Installs the mysql connector jar to the server lib directory.

Definitions
===================

Data source
---------------------

This definition installs a data source into the deploy directory.

# Attribute Parameters

- name: name attribute. The name of the datasource file and the jndi location.
- template: What template to use for the datasource, default: datasource.xml.erb
- min_pool_size: minimum connection pool size, default: 5
- max_pool_size: maximum connection pool size, default: 20
- idle_timeout_minutes: timeout for idle connections, default: 5 
- connection_check: what sql command to run to check a connection, default: SELECT 1 FROM dual
- driver_class: what java driver class to use, default: com.mysql.jdbc.Driver 
- connection_url: JDBC connection URL, default: jdbc:mysql://localhost:3306/jboss
- username: username to access the database, default: jboss
- password: password to access the database, default: jboss

# Examples

    # Configure the connection and password
    datasource "myapp" do
      connection_url "jdbc:mysql://db.example.com:3306/myapp"
      password "myapp-secret"
    end


Resources/Providers
===================

Managing Web Applications
---------------------

This LWRP provides an easy way to manage web applications.

# Actions

- :deploy: default. installs the web application
- :undeploy: removes the web application

# Attribute Parameters

Either a path, or a uri can be used. If both are passed in, the path will be used.

- name: name attribute. The name of the web application file, including extension  
- uri: the uri location of the web application file
- path: local path the web application file

# Examples

    # deploy from a uri
    jboss_webapp "myapp.war" do
      uri "http://nexus.example.com/releases/com/example/myapp/1.0.0/myapp-1.0.0.war"
    end

    # deploy from a local path
    jboss_webapp "myapp.war" do
      path "/tmp/myapp-1.0.0.war"
    end

    # undeploy a web application
    jboss_webapp "myapp.war" do
      action :undeploy
    end

To-Do
==================

* Add support for disabling and adjusting auto deployment
** Update definitions and providers to check and restart
* Add a provider to allow installing a custom server folder from a path or URI

License and Author
==================

Author:: Josh Kennedy (<josh@meltmedia.com>)

Copyright 2012, Meltmedia

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
