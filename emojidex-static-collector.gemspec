Gem::Specification.new do |s|
  s.name        = 'emojidex-static-collector'
  s.version     = '0.0.1'
  s.license     = 'emojiOL'
  s.summary     = 'Create static collections from emojidex assets'
  s.description = 'Generates PNG rasters from emojidex vectors in a ' \
                  'specified size and manually sorts them into ' \
                  'categorized folders.'
  s.authors     = ['Rei Kagetsuki']
  s.email       = 'info@emojidex.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.bindir      = 'bin'
  s.executables << 'emojidex-static-collector'
  s.homepage    = 'http://developer.emojidex.com'

  s.add_dependency 'emojidex'
  s.add_dependency 'emojidex-vectors'
  s.add_dependency 'emojidex-converter'
end
