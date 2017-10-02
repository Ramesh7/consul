
package 'consul'

user "consul" do
  comment "Consul System Daemon"
  system true
  gid 'deploy'
  shell '/sbin/nologin'
  action :create
  not_if "getent passwd consul"
end

directory "/etc/consul/data" do
  recursive true
  owner 'consul'
  group 'deploy'
  mode '0754'
  only_if "getent passwd consul"
end

template "/etc/init.d/consul" do
  source 'etc/init.d/consul.erb'
  owner 'consul'
  group 'deploy'
  mode 0644
  variables(
    daemon_type: node['coupa-base']['nodename'].match(/rls/) ? 'server' : 'agent'
  )
end

cookbook_file "/etc/monit.d/consul" do
  source 'etc/monit.d/consul'
  mode 0644
  notifies :reload, 'service[monit]', :immediately
end

cookbook_file "/etc/logrotate.d/consul" do
  source 'etc/logrotate.d/consul'
  mode 0644
end

template "/etc/consul/config.json" do
  source "etc/consul/config.json.erb"
  user 'consul'
  group 'deploy'
  mode '0600'
  variables(
    deployment: node['coupa-base']['data_bag'],
    node_name: node['coupa-base']['nodename'],
    is_server: node['coupa-base']['nodename'].match(/rls/) ? true : false
  )
  notifies :restart, 'service[consul]', :immediately
end

service 'consul'
