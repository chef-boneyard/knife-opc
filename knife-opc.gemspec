$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-opc/version'

Gem::Specification.new do |s|
  s.name = 'knife-opc'
  s.version = KnifeOPC::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.summary = "Knife Tools for Opscode Chef Server"
  s.description = s.summary
  s.author = "Steven Danna"
  s.email = "steve@opscode.com"
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "chef"
  s.add_development_dependency "sdoc"
end
