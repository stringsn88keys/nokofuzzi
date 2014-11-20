lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Gem::Specification.new do |s|
  s.name = 'nokofuzzi'
  s.version = '0.1.1'
  s.authors = ['Thomas Powell']
  s.email = ['twilliampowell@gmail.com']
  s.homepage = 'https://github.com/stringsn88keys/nokofuzzi'
  s.license = 'MIT'
  s.summary = 'Iterators and methods for Nokogiri for fuzz testing of applications'
  s.description = 'Monkey patches on Nokogiri::XML::Document for manipulation of documents for tests'
  s.rdoc_options = ['--charset', 'UTF-8']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.rdoc_options = ['--charset', 'UTF-8']
  s.extra_rdoc_files = %w[README.md LICENSE]
  # Manifest
  s.files = Dir.glob("lib/**/*")
  s.test_files = Dir.glob("{test,spec,features}/**/*")
  s.executables = Dir.glob("bin/*").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_dependency 'nokogiri', '>= 1.6', '< 1.9'
  s.add_development_dependency 'rspec', '~> 3.0'
end
