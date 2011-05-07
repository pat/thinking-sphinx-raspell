YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'thinking-sphinx-raspell'
  gem.summary     = 'An add-on gem for spelling suggestions in Thinking Sphinx'
  gem.description = 'Adds spelling suggestions to Thinking Sphinx searches.'
  gem.email       = 'pat@freelancing-gods.com'
  gem.homepage    = 'http://ts.freelancing-gods.com'
  gem.authors     = 'Pat Allan'
  
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
