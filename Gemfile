source "https://rubygems.org"
gem 'rails',                    '~> 3.2.21'
gem 'minitest',                 '~> 3.2.0'
gem 'fast_gettext',             '~> 0.6.8'
gem 'acts-as-taggable-on',      '~> 3.4.2'
gem 'rails_autolink',           '~> 1.1.5'
gem 'pg',                       '~> 0.13.2'
gem 'rmagick',                  '~> 2.13.1'
gem 'RedCloth',                 '~> 4.2.9'
gem 'will_paginate',            '~> 3.0.3'
gem 'ruby-feedparser',          '~> 0.7'
gem 'daemons',                  '~> 1.1.5'
gem 'thin',                     '~> 1.3.1'
gem 'nokogiri',                 '~> 1.5.5'
gem 'rake', :require => false
gem 'grape',					'~> 0.2.1'
gem 'rest-client',              '~> 1.6.7'
gem 'exception_notification',   '~> 4.0.1'
gem 'gettext',                  '~> 2.2.1', :require => false
gem 'locale',                   '~> 2.0.5'
gem 'whenever', :require => false
gem 'eita-jrails', '>= 0.9.5', :require => 'jrails'
gem 'grape',                    '~> 0.8.0'
gem 'grape-entity'
gem 'grape-swagger'
gem 'rack-cors'
gem 'rack-contrib'

#gem 'grape-swagger-rails'

# FIXME list here all actual dependencies (i.e. the ones in debian/control),
# with their GEM names (not the Debian package names)

group :assets do
  gem 'uglifier', '>= 1.0.3'
  gem 'sass-rails'
end

group :production do
  gem 'dalli', '~> 2.7.0'
end

group :test do
  gem 'rspec',                  '~> 2.10.0'
  gem 'rspec-rails',            '~> 2.10.1'
  gem 'mocha',                  '~> 1.1.0', :require => false
end

group :cucumber do
  gem 'cucumber-rails',         '~> 1.0.6', :require => false
  gem 'capybara',               '~> 2.1.0'
  gem 'cucumber',               '~> 1.0.6'
  gem 'database_cleaner',       '~> 1.2.0'
  gem 'selenium-webdriver',     '~> 2.39.0'
end

# Requires custom dependencies
eval(File.read('config/Gemfile'), binding) rescue nil

# include gemfiles from enabled plugins
# plugins in baseplugins/ are not included on purpose. They should not have any
# dependencies.
Dir.glob('config/plugins/*/Gemfile').each do |gemfile|
  eval File.read(gemfile)
end
