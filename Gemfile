source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '4.0.6'

gem 'rails', '~> 8.1.3'

# Asset pipeline. This app uses Sprockets manifests (//= require, require_tree)
# rather than Rails 8's default Propshaft, so sprockets-rails is declared explicitly.
gem 'sprockets-rails'
gem 'terser' # ES6-capable JS compressor; replaces uglifier

# SPA-like navigation. Replaces turbolinks, which is end-of-life.
gem 'turbo-rails'

# Attachment variants for ClassroomRegister#images are currently DISABLED.
#
# Active Storage 8.1 refuses to boot when ruby-vips is present but the system
# libvips is older than 8.13, because it cannot disable libvips' "unfuzzed"
# operations, which are unsafe on untrusted uploads. This host has libvips
# 8.9.1 and Ubuntu 20.04 ships nothing newer. image_processing hard-depends on
# ruby-vips, so it cannot be kept without dragging that failure in.
#
# ImageMagick is also not installed here, so the mini_magick backend has no
# binary to call either -- image variants have no working processor on this
# host in any case.
#
# To re-enable: install libvips >= 8.13 (PPA or source build), then uncomment.
# See docs/upgrade-notes.md.
# gem 'image_processing', '~> 1.2'
# gem 'mini_magick'

gem 'puma', '>= 6.0'
gem 'jbuilder', '~> 2.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# PostgreSQL in every environment, so development matches production.
gem 'pg', '~> 1.5'

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]
