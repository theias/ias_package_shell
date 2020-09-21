require 'pp'

executables = Dir['bin/*.rb']
executables.each do | e |
	e.gsub!(/^bin\//, '')
end


Gem::Specification.new do |s|
  s.name        = '[% project.package_name %]'
  s.version     = '0.0.0'
  s.date        = '2020-09-21'
  s.summary     = "Summary"
  s.description = "Description"
  s.authors     = ["SomeAuthor"]
  s.email       = 'someemail@example.com'
  s.files       = Dir['lib/**/*']
  s.executables = executables
  s.homepage    =
    'https://example.com/SomeGem'
  s.license       = 'GPL-3.0'
end
