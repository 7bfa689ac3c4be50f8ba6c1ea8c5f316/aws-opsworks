#
# Cookbook Name:: nginx
# Recipe:: force_ssl_on_elb
# Author::
#

Chef::Log.info("Starting force_ssl_on_elb ... node=#{node[:nginx][:force_ssl_on_elb]}")
node.force_default[:nginx][:force_ssl_on_elb] = true
Chef::Log.info("Starting 2nd force_ssl_on_elb ... node=#{node[:nginx][:force_ssl_on_elb]}")
include_recipe "nginx"
