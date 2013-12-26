#
# Cookbook Name:: cross-compile
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

package "git" do
  action :install
end

user_dir = "/home/rg2"

required_packages = [
  "mingw-w64",
  "dh-autoreconf",
  "intltool",
  "libint-dev",
  "libffi-dev",
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
  user "rg2"
end

git File.join(work_dir, "ruby-gnome2.win32") do
  repository "https://github.com/ruby-gnome2/ruby-gnome2"
  reference "master"
  action :checkout
  user "rg2"
end

git File.join(work_dir, "rcairo.win32") do
  repository "https://github.com/rcairo/rcairo"
  reference "master"
  action :checkout
  user "rg2"
end

git File.join(work_dir, "pkg-config") do
  repository "https://github.com/ruby-gnome2/pkg-config"
  reference "master"
  action :checkout
  user "rg2"
end

rbenv_script "compiling-cross-ruby-1.9" do
  rbenv_version "1.9.3-p484"
  not_if "cat /home/rg2/.rake-compiler/config.yml | grep i686-w64-mingw32 | grep ruby-1.9"
  code <<-END_OF_CODE
    gem update --system
    gem install rake-compiler
    rake-compiler cross-ruby HOST=i686-w64-mingw32 VERSION=1.9.3-p484 EXTS=--without-extensions
  END_OF_CODE
  user "rg2"
end

rbenv_script "compiling-cross-ruby-2.0" do
  rbenv_version "2.0.0-p353"
  not_if "cat /home/rg2/.rake-compiler/config.yml | grep i686-w64-mingw32 | grep ruby-2.0"
  code <<-END_OF_CODE
    rake-compiler cross-ruby HOST=i686-w64-mingw32 VERSION=2.0.0-p353 EXTS=--without-extensions
  END_OF_CODE
  user "rg2"
end
