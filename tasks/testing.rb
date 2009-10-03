require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs      << 'lib' << 'spec'
  spec.spec_opts << '-c'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs      << 'lib' << 'spec'
  spec.spec_opts << '-c'
  spec.pattern    = 'spec/**/*_spec.rb'
  spec.rcov       = true
  spec.rcov_opts  = [
    '--exclude', 'spec',
    '--exclude', 'gems',
    '--exclude', 'ruby'
  ]
end

task :spec => :check_dependencies
