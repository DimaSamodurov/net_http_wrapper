lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'net_http_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'net_http_wrapper'
  spec.version       = NetHttpWrapper::VERSION
  spec.authors       = ['Dmytro Samodurov']
  spec.email         = ['dimasamodurov@gmail.com']

  spec.summary       = 'Net::HTTP request wrapper.'
  spec.description   = 'Wraps Net::HTTP requests e.g. for logging purposes.'
  spec.homepage      = 'https://github.com/dimasamodurov/net_http_wrapper'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.5.1'
  spec.add_development_dependency 'rubocop'
end
