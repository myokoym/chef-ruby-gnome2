#
# Cookbook Name:: ruby-compile
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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

user_dir = "/home/myokoym"

git File.join(user_dir, ".rbenv") do
  repository "https://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user "myokoym"
end

directory File.join(user_dir, ".rbenv", "plugins") do
  recursive false
  action [:create]
  user "myokoym"
end

git File.join(user_dir, ".rbenv", "plugins", "ruby-build") do
  repository "https://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user "myokoym"
end

bash "rbenv-prepare" do
  not_if "which rbenv"
  environment "HOME" => "/home/myokoym"
  code <<-END_OF_CODE
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' > /home/myokoym/.bash_profile
    echo 'eval "$(rbenv init -)"' >> /home/myokoym/.bash_profile
  END_OF_CODE
  user "myokoym"
end

bash "rbenv-install" do
  not_if "ruby -v | grep -E 2.0.0"
  environment "HOME" => "/home/myokoym"
  code <<-END_OF_CODE
    source /home/myokoym/.bash_profile
    rbenv install 2.0.0-p353
    rbenv install 1.9.3-p484
  END_OF_CODE
  user "myokoym"
end