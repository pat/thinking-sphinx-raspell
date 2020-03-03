Gem::Specification.new do |s|
  s.name          = "thinking-sphinx-raspell"
  s.version       = "1.1.2"
  s.authors       = ["Pat Allan"]
  s.email         = "pat@freelancing-gods.com"

  s.homepage      = "https://github.com/pat/thinking-sphinx-raspell"
  s.summary       = "An add-on gem for spelling suggestions in Thinking Sphinx"
  s.description   = "Adds spelling suggestions to Thinking Sphinx searches."

  s.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |file| File.basename(file) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "raspell", ">= 1.2.2"
  s.add_runtime_dependency "thinking-sphinx", [">= 1.2.12", "< 3"]

  s.add_development_dependency "rspec", "~> 2.99"
  s.add_development_dependency "yard",  "~> 0.9"
end
