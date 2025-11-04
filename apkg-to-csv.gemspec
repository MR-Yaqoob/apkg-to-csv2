require_relative 'lib/apkg_to_csv/version'

Gem::Specification.new do |spec|
  spec.name = 'apkg-to-csv'
  spec.version = ApkgToCsv::VERSION
  spec.licenses = ['MIT']
  spec.authors = ['zfletch']
  spec.email = ['zf.rubygems@gmail.com']

  spec.summary = 'Convert Anki decks to CSV'
  spec.description = 'Convert Anki deck (.apkg) files to comma-separated values (.csv) files.'
  spec.homepage = 'https://github.com/zfletch/apkg-to-csv'
  spec.required_ruby_version = '>= 3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = [
    'Gemfile',
    'Gemfile.lock',
    'LICENSE',
    'README.md',
    'apkg-to-csv.gemspec',
    'bin/apkg-to-csv',
    'lib/apkg_to_csv.rb',
    'lib/apkg_to_csv/csv.rb',
    'lib/apkg_to_csv/model.rb',
    'lib/apkg_to_csv/note.rb',
    'lib/apkg_to_csv/version.rb',
  ]
  spec.require_paths = ['lib']
  spec.bindir = 'bin'
  spec.executables = ['apkg-to-csv']
  spec.add_runtime_dependency "sinatra"
  spec.add_dependency 'rubyzip', '~> 2.3'
  spec.add_dependency 'sqlite3', '~> 1.6'
end
