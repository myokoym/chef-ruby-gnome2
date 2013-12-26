#
# Cookbook Name:: ruby-compile
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "rg2" do
  home "/home/rg2"
  shell "/bin/bash"
  supports :manage_home => true
  action [:create, :manage]
end

required_packages = [
  "git",
  "libssl-dev",
  "zlib1g-dev",
]

required_packages.each do |_package|
  package _package do
    action :install
  end
end

user_dir = "/home/rg2"

git File.join(user_dir, ".rbenv") do
  repository "https://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user "rg2"
end

directory File.join(user_dir, ".rbenv", "plugins") do
  recursive false
  action [:create]
  user "rg2"
end

git File.join(user_dir, ".rbenv", "plugins", "ruby-build") do
  repository "https://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user "rg2"
end

bash "rbenv-prepare" do
  not_if "which rbenv"
  code <<-END_OF_CODE
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >>/home/rg2/.bash_profile
    echo 'eval "$(rbenv init -)"' >>/home/rg2/.bash_profile
    source /home/rg2/.bash_profile
  END_OF_CODE
  user "rg2"
end

bash "rbenv-install-2.0.0-p353" do
  not_if "rbenv versions | grep 2.0.0-p353"
  code "rbenv install 2.0.0-p353"
  user "rg2"
end

bash "rbenv-install-1.9.3-p484" do
  not_if "rbenv versions | grep 1.9.3-p484"
  code "rbenv install 1.9.3-p484"
  user "rg2"
end
