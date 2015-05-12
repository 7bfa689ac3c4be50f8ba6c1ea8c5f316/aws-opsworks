#
# Cookbook Name:: nginx
# Recipe:: force_ssl_on_elb
# Author::
#

node[:nginx][:force_ssl_on_elb] = true
include_recipe "nginx"
