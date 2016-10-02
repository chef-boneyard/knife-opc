#
# Author:: Adam Jacob (<adam@chef.io>)
# Author:: Daniel DeLeo (<dan@chef.io>)
# Copyright:: Copyright (c) 2008-2016 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "rubygems"
require "rubygems/package_task"
require "rdoc/task"

GEM_NAME = "knife-opc"

spec = eval(File.read("knife-opc.gemspec"))

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

begin
  require "sdoc"

  Rake::RDocTask.new do |rdoc|
    rdoc.title = "Chef Ruby API Documentation"
    rdoc.main = "README.md"
    rdoc.options << "--fmt" << "shtml" # explictly set shtml generator
    rdoc.template = "direct" # lighter template
    rdoc.rdoc_files.include("README.md", "LICENSE", "lib/**/*.rb")
    rdoc.rdoc_dir = "rdoc"
  end
rescue LoadError
  puts "sdoc is not available. (sudo) gem install sdoc to generate rdoc documentation."
end

task :install => :package do
  sh %{gem install pkg/#{GEM_NAME}-#{KnifeOPC::VERSION} --no-rdoc --no-ri}
end

task :uninstall do
  sh %{gem uninstall #{GEM_NAME} -x -v #{KnifeOPC::VERSION} }
end

begin
  require "rspec/core/rake_task"

  desc "Run all specs in spec directory"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

rescue LoadError
  STDERR.puts "\n*** RSpec not available. (sudo) gem install rspec to run unit tests. ***\n\n"
end

begin
  require "chefstyle"
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:style) do |task|
    task.options << "--display-cop-names"
  end
rescue LoadError
  STDERR.puts "\n*** chefstyle not available. (sudo) gem install chefstyle to run unit tests. ***\n\n"
end

task default: [:spec, :style]
