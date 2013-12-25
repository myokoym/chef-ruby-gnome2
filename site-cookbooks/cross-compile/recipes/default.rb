#
# Cookbook Name:: cross-compile
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "myokoym" do
  home "/home/myokoym"
  shell "/bin/bash"
  supports :manage_home => true
  action [:create, :manage]
end

package "git" do
  action :install
end

user_dir = "/home/myokoym"

gem_package "rake" do
  action :install
end

required_packages = [
  "mingw-w64",
  "dh-autoreconf",
  "intltool",
  "libint-dev"
  "libffi",
  "flex",
  "bison",
  "python-dev",
  "gtk-doc-tools",
  "unzip",
]

required_packages.each do |_package|
  package _package do
    action :install
  end
end

work_dir = File.join(user_dir, "work", "ruby")

directory work_dir do
  recursive true
  action [:create]
  user "myokoym"
end

git File.join(work_dir, "ruby-gnome2.win32") do
  repository "https://github.com/ruby-gnome2/ruby-gnome2"
  reference "master"
  action :checkout
  user "myokoym"
end

git File.join(work_dir, "rcairo.win32") do
  repository "https://github.com/rcairo/rcairo"
  reference "master"
  action :checkout
  user "myokoym"
end

git File.join(work_dir, "pkg-config") do
  repository "https://github.com/ruby-gnome2/pkg-config"
  reference "master"
  action :checkout
  user "myokoym"
end
