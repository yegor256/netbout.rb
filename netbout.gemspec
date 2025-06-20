# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/netbout/version'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.3'
  s.name = 'netbout'
  s.version = Netbout::VERSION
  s.license = 'MIT'
  s.summary = 'Netbout API client'
  s.description = 'Connects to Netbout.com and enables manipulation of all entities'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/yegor256/netbout.rb'
  s.files = `git ls-files`.split($RS)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_runtime_dependency 'backtrace', '~>0.3'
  s.add_runtime_dependency 'iri'
  s.add_runtime_dependency 'json', '~>2.2'
  s.add_runtime_dependency 'openssl', '>=1.0'
  s.add_runtime_dependency 'rainbow', '~>3.0'
  s.add_runtime_dependency 'typhoeus', '~>1.3'
  s.metadata['rubygems_mfa_required'] = 'true'
end
