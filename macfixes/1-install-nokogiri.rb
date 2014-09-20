#!/usr/bin/env ruby
#
# Mac fix 1 - Install the Nokogiri gem on Mac OS 10.9 Mavericks
#
# Usage: to configure and install using Bundler, pass in 'bundle' as an argument to the script.
#
# Nokogiri works at a very low level, so it has many issues on various platforms.
# As a result, the command `install gem nokogiri` often will fail. This fix is for
# errors involving 'libiconv', such as the following one I encountered:
#
# > libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html
# > for help with installing dependencies.
# > -----
# > *** extconf.rb failed ***
# > Could not create Makefile due to some reason, probably lack of necessary
# > libraries and/or headers.  Check the mkmf.log file for more details.  You may
# > need configuration options.
#
# This script is basically just carrying out the install process illustrated on the
# Nokogiri website, specifically for OS X 10.9. Other systems are not covered.
# More information can be found at: http://nokogiri.org/tutorials/installing_nokogiri.html
#
# Some additional resources I came across while troubleshooting this issue:
# - http://stackoverflow.com/questions/5528839/why-does-installing-nokogiri-on-mac-os-fail-with-libiconv-is-missing
# - http://stackoverflow.com/questions/23401174/nokogiri-gem-fails-to-install-in-os-x-mavericks
# - http://stackoverflow.com/questions/19643153/error-to-install-nokogiri-on-osx-10-9-maverick
# - http://jasdeep.ca/2013/10/installing-nokogiri-fails-os-x-mavericks/
#
# NOTE:
# There are many factors involved in Nokogiri's installation. This script was tested
# on a system with the following characteristics and installations:
#
# - Mac OS X 10.9.4
# - 'xcode-select' installed
# - Homebrew 0.9.5
# - Ruby 2.1.2
# - Nokogiri 1.6.3.1

# There are three libraries required to compile Nokogiri's native extensions
libs = %w[libxml2 libxslt libiconv]

# Install and link them using Homebrew
`brew update`
%w[install link].each { |command| `brew #{command} #{libs.join(' ')}` }

# Use the latest versions of installed libraries from your Homebrew installation
paths = libs.inject({}) do |libs, lib|
  # It's easy to find the library paths with the 'brew' executable
  # In fact, it's probably not even necessary to use Pathname or #realpath
  libs[lib.to_sym] = File.realpath `brew --prefix #{lib}`.chomp
  libs
end

# If you have any Nokogiri gem files, they need to be removed obviously
`gem uninstall nokogiri`

# Install Nokogiri gem using either RubyGems or Bundler (defaults to RubyGems)
flags = [
  '--',
  "--with-xml2-dir=#{paths[:libxml2]}",
  "--with-xslt-dir=#{paths[:libxslt]}",
  "--with-iconv-dir=#{paths[:libxml2]}",
  "--with-xml2-config=#{paths[:libxml2]}/bin/xml2-config",
  "--with-xslt-config=#{paths[:libxslt]}/bin/xslt-config"
]
if ARGV[0] == 'bundle'
  `bundle config build.nokogiri #{flags.drop(1).join(' ')}`
  print `bundle exec install nokogiri`
else
  print `gem install nokogiri #{flags.join(' ')}`
end

puts
puts "Mac 'Nokogiri installation' fix applied successfully! Latest version at: " +
     'https://gist.github.com/SteveBenner/de51738222e92d606487'