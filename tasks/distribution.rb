require 'yard'
require 'jeweler'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'thinking-sphinx-raspell'
  gem.summary     = 'An add-on gem for spelling suggestions in Thinking Sphinx'
  gem.description = 'Adds spelling suggestions to Thinking Sphinx searches.'
  gem.email       = 'pat@freelancing-gods.com'
  gem.homepage    = 'http://ts.freelancing-gods.com'
  gem.authors     = 'Pat Allan'
  gem.add_dependency 'thinking-sphinx', '>= 1.2.12'
  gem.add_dependency 'raspell',         '>= 1.1'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
  
  gem.files = FileList[
    "lib/**/*.rb",
    "LICENSE",
    "README.textile",
    "VERSION.yml"
  ]
  gem.test_files = FileList[
    "spec/**/*.rb"
  ]
end

Jeweler::GemcutterTasks.new
