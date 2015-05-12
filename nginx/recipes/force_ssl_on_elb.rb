#
# Cookbook Name:: nginx
# Recipe:: force_ssl_on_elb
# Author::
#

node.default["nginx"]["force_ssl_on_elb"] = true
include_recipe "nginx"
