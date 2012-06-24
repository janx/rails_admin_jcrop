$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_jcrop/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_jcrop"
  s.version     = RailsAdminJcrop::VERSION
  s.authors     = ["Jan Xiej"]
  s.email       = ["jan.h.xie@gmail.com"]
  s.homepage    = "http://github.com/janx/rails_admin_jcrop"
  s.summary     = "JCrop field for rails admin"
  s.description = "Easy image crop tool in your form."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.x"

  s.add_development_dependency "sqlite3"
end
