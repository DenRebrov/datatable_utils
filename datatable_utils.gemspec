$:.push File.expand_path("../lib", __FILE__)

require "datatable_utils/version"

Gem::Specification.new do |s|
  s.name        = "datatable_utils"
  s.version     = DatatableUtils::VERSION
  s.authors     = ["denispeplin"]
  s.email       = ["denis.peplin@gmail.com"]
  s.homepage    = "https://github.com/denispeplin/datatable_utils"
  s.summary     = "Utilites for server-side datatables"
  s.description = "Module for including into server-side datatables class"

  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
end