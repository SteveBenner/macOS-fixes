#!/usr/bin/env ruby
#
# Homebrew fix 1 - osxfuse dylibs
#
# original solutions: https://gist.github.com/aaronzirbes/3239033
#                     https://gist.github.com/trinitronx/5437061
#
# Fixes the following:
#
# > Warning: Unbrewed dylibs were found in /usr/local/lib.
#
# > Unexpected dylibs:
# >     /usr/local/lib/libmacfuse_i32.2.dylib
# >     /usr/local/lib/libmacfuse_i64.2.dylib
# >     /usr/local/lib/libosxfuse_i32.2.dylib
# >     /usr/local/lib/libosxfuse_i64.2.dylib
#
# > Warning: Unbrewed .la files were found in /usr/local/lib.
#
# > Unexpected .la files:
# >     /usr/local/lib/libosxfuse_i32.la
# >     /usr/local/lib/libosxfuse_i64.la
#
# > Warning: Unbrewed .pc files were found in /usr/local/lib/pkgconfig.
#
# > Unexpected .pc files:
# >     /usr/local/lib/pkgconfig/osxfuse.pc

LIBS = %w[
  libmacfuse_i32.2.dylib
  libosxfuse_i32.2.dylib
  libosxfuse_i64.2.dylib
  libmacfuse_i64.2.dylib
  libosxfuse_i32.la
  libosxfuse_i64.la
  pkgconfig/osxfuse.pc
].map {|libname| "/usr/local/lib/#{libname}" }

TRUECRYPT_LIB_PATH = '/Applications/TrueCrypt.app/Contents/Resources/Library'

abort "This fix appears to be unnecessary! Diagnose issues by running 'brew doctor'." unless LIBS.detect do |lib|
  !(File.exist?("#{TRUECRYPT_LIB_PATH}/#{File.basename(lib)}") && File.symlink?(lib))
end

begin
  require 'fileutils'
rescue # perform ops using shell
  `mkdir -p #{TRUECRYPT_LIB_PATH}` unless Dir.exist? TRUECRYPT_LIB_PATH
  LIBS.each do |lib|
    libdir = "#{TRUECRYPT_LIB_PATH}/#{lib}"
    abort "Failed to copy #{lib} to #{libdir}" unless `cp -v #{lib} #{libdir}`
    abort "Failed to remove #{lib}" unless `rm -v #{lib}`
  end
else # perform ops using Ruby
  FileUtils.mkdir_p TRUECRYPT_LIB_PATH unless Dir.exist? TRUECRYPT_LIB_PATH
  FileUtils.cp LIBS, TRUECRYPT_LIB_PATH, :verbose => true
  FileUtils.rm LIBS, :verbose => true
ensure
  LIBS.each {|lib| File.symlink "#{TRUECRYPT_LIB_PATH}/#{File.basename(lib)}", lib }
end

puts "Homebrew 'osxfuse dylib' fix applied successfully! Latest version at: https://gist.github.com/SteveBenner/10938596"
puts `brew prune && brew doctor`
