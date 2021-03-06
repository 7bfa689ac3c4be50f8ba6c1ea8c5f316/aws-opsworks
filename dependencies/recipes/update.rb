#
# Cookbook Name:: dependencies
# Recipe:: update

case node["opsworks"]["ruby_stack"]
when "ruby"
  include_recipe "ruby"
end

include_recipe "opsworks_nodejs" if node["opsworks"]["instance"]["layers"].include?("nodejs-app")

include_recipe 'packages'
include_recipe 'gem_support'

case node[:platform]
when 'centos','redhat','fedora','amazon'
  ruby_block "upgrade the release version lock" do
    block do
      rc = Chef::Util::FileEdit.new("/etc/yum.conf")
      release_line = "releasever=#{node[:dependencies][:os_release_version]}"
      rc.search_file_replace_line /^\s*releasever\s*=/, release_line
      rc.write_file
    end
    only_if do
      node[:dependencies][:os_release_version] && ::File.exists?("/etc/yum.conf")
    end
  end

  #if node[:dependencies][:upgrade_rpms] - not implemented in the application jet
  if node[:dependencies][:upgrade_debs]
    execute 'yum -y update' do
      action :run
    end
  end

  execute "/sbin/shutdown -r +2 &" do
    only_if do
      installed_kernels = OpsWorks::ShellOut.shellout("rpm -q --last kernel")
      latest_installed_kernel = installed_kernels.gsub(/^kernel-(\S+).*/, '\1').lines.first.strip
      current_used_kernel = OpsWorks::ShellOut.shellout("uname -r").strip
      reboot_required = latest_installed_kernel != current_used_kernel
      if node[:dependencies][:allow_reboot]
        reboot_required
      elsif reboot_required && !node[:dependencies][:allow_reboot]
        Chef::Log.warn("reboot required but not allowed")
        false
      else
        false # not required and not allowed
      end
    end
  end
when 'debian','ubuntu'
  if node[:dependencies][:update_debs]
    execute 'apt-get update' do
      action :run
    end
  end

  if node[:dependencies][:upgrade_debs]
    execute 'apt-get upgrade -y' do
      action :run
    end
  end
end
