$:.unshift(File.dirname(__FILE__) + "/lib")
require "knife-opc/version"

Gem::Specification.new do |s|
  s.name = "knife-opc"
  s.version = KnifeOPC::VERSION
  s.summary = "Knife Tools for Chef Server"
  s.description = s.summary
  s.author = "Steven Danna"
  s.email = "steve@chef.io"
  s.homepage = "https://github.com/knife-opc"
  s.license = "Apache-2.0"
  s.require_path = "lib"
  s.files = %w{LICENSE} + Dir.glob("lib/**/*")
end
