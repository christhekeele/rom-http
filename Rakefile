require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc 'Run CI tasks'
task ci: [:spec, :examples]

desc 'Open a console preloaded with this library'
task :console, :cmd do |_, args|
  args.with_defaults(cmd: pry_enabled? ? 'pry' : 'irb')
  sh "bundle exec #{args[:cmd]} -I lib -r rom-http.rb"
end

def pry_enabled?
  begin
    require 'pry'
  rescue LoadError
    false
  end
end
