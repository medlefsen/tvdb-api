Gem::Specification.new do |s|
  s.name        = 'tvdb-api'
  s.version     = '1.0.1'
  s.summary     = "Straightforward Ruby client for TVDB"
  s.description = "Clean Ruby API interface to The TVDB"
  s.authors     = ["Matt Edlefsen"]
  s.email       = 'matt@xforty.com'
  s.files       = `git ls-files`.split("\n")
  s.license     = "MIT"
  s.homepage    = 'https://github.com/medlefsen/tvdb-api'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [
    "Readme.md"
  ]
  s.add_dependency('httparty', '~> 0.10.0')
end
