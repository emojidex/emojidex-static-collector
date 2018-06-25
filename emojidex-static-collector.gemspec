Gem::Specification.new do |s|
  s.name        = 'emojidex-static-collector'
  s.version     = '0.3.2'
  s.license     = 'emojiOL'
  s.summary     = 'Create static collections from emojidex assets'
  s.description = 'Generates PNG rasters from emojidex vectors in a ' \
                  'specified size and manually sorts them into ' \
                  'categorized folders.'
  s.authors     = ['Rei Kagetsuki']
  s.email       = 'info@emojidex.com'
  s.files       = Dir.glob('lib/**/*.rb') +
                  Dir.glob('bin/**/*.rb') +
                  ['emojidex-static-collector.gemspec']
  s.require_paths = ['lib']
  s.bindir      = 'bin'
  s.executables << 'emojidex-static-collector'
  s.homepage    = 'http://developer.emojidex.com'

  s.add_dependency 'emojidex', '~> 0.5', '~> 0.5.2'
  s.add_dependency 'emojidex-vectors', '~> 1.0'
  s.add_dependency 'emojidex-converter', '~> 0.4', '~> 0.4.1'
end
