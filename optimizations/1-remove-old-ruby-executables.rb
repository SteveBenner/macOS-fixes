#!/usr/bin/env ruby
#
# Optimization 1 - Remove executables affiliated with outdated Ruby installations
#
# OS X comes packaged with an outdated Ruby installation that should be replaced ASAP, even
# if only for security reasons. One issue that can arise from using the System Ruby is
# creation of executables in the PATH which are designated for use with the System Ruby.
# For instance, this can be occur when installing certain gems via RubyGems. Such
# executables conflict with those of the same name installed for newer Rubies, and often
# go undetected until they cause secondary issues... Essentially, these are undesirable.
#
# This script removes all executables on your PATH configured to use the System Ruby.
#
# NOTE: This script might require root access, necessitating the use of 'sudo' to execute
#
require 'pathname'

# todo: add colors

SYSTEM_RUBY_LOCATION = '/System/Library/Frameworks/Ruby.framework'
BACKUP_LOCATION = Pathname('~/.backup/osx/executables/').expand_path

# Collect list of all possible executables available from directories in your PATH
EXECUTABLES = ENV['PATH'].split(':').collect_concat do |d|
  next unless Pathname(d).directory?
  Pathname(d).expand_path.children.select { |f| f.file? && f.executable? }
end

# Culprit executables are identified by the first line of text, or 'shebang', which indicates
# to the system which interpreter the file should be executed with.
shebang_text = SYSTEM_RUBY_LOCATION.prepend '#!'
UNCLEAN = EXECUTABLES.compact.select { |f| f.readlines.first.scrub.match(shebang_text) }

puts "#{UNCLEAN.count} nasty executable files have been identified that should be removed " +
  'from your system immediately:'
sleep 1
puts UNCLEAN
puts "Enter 'y' to remove these files (backups will be created at #{BACKUP_LOCATION}), " +
  'or anything else to exit.'
user_decision = gets

exit unless user_decision =~ /^y|Y/

require 'fileutils'
BACKUP_LOCATION.mkpath unless BACKUP_LOCATION.directory?
UNCLEAN.each do |f|
  # Create backups of all the files to be deleted, just in case
  FileUtils.copy f, BACKUP_LOCATION
  f.delete
  puts "Removed #{f}."
end
