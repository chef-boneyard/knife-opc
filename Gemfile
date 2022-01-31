source "https://rubygems.org"

# Specify the gem's dependencies in knife-opc.gemspec
gemspec

group :docs do
  gem "yard"
  gem "redcarpet"
  gem "github-markup"
end

group :test do
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.6")
    gem "chef-zero", "~> 14"
    gem "chef", "~> 15"
  else
    gem "chef", "~> 16"
  end
  gem "chefstyle"
  gem "rspec", "~> 3.0"
  gem "rake"
  gem "simplecov"
end
