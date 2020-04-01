# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name = 'CnpChargeback'
  spec.version = CnpChargeback::VERSION
  spec.authors = ['Micki Balder']
  spec.email = ['micki.balder@food52.com']
  spec.summary = 'Food52 Forked version of CnpChargeback from Vantiv/WorldPay'
  spec.description = 'A wrapper for the Vantiv/WorldPay CnpChargeback API'
  spec.homepage = 'https://github.com/food52/cnp-chargeback-sdk-ruby'
  spec.platform = Gem::Platform::RUBY
  spec.license = 'MIT'

  spec.files = Dir['**/**']
  spec.executables = ['sample_driver.rb', 'Setup.rb']
  spec.test_files = Dir['test/unit/ts_unit.rb']

  spec.add_dependency('xml-object')
  spec.add_dependency('xml-mapping')
  spec.add_dependency('mimemagic')
  spec.add_dependency('net-sftp')
  spec.add_dependency('libxml-ruby')
  spec.add_dependency('crack')
  spec.add_dependency('iostreams')
  spec.add_development_dependency('mocha')
end