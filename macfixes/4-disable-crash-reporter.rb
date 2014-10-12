#!/usr/bin/env ruby
#
# Mac fix 4 - Disable CrashReporter
#
# CrashReporter is a daemon that monitors for crashes and generates a report (duh) when they occur.
# If an application (such as Finder) become stuck in an infinite crash loop, then sometimes it's
# desirable to just turn off CrashReporter entirely, as it will continually generate processes in
# the background which spew errors and logs, resulting in massive overhead to your system resources.
#
# NOTE: This script requires root access, so it might be necessary to use 'sudo' when executing it
#
# Resources
# - http://hints.macworld.com/article.php?story=20090902164105138
# - https://jonathansblog.co.uk/disable-reportcrash-osx-lion
# - https://discussions.apple.com/thread/3837385?tstart=0
# - https://discussions.apple.com/thread/4525486?start=15&tstart=0
#
# todo: test 'restore' functionality
#
require 'optparse'
require 'pathname'

# Command line interface
opts = {quiet: false}
OptionParser.new do |cli|
  cli.summary_width = 16
  cli.summary_indent = ' ' * 2
  cli.banner = <<-EOS
Usage: execute this script every time you login (one way to do this is in your shell profile)
Commands:
  restore # Causes the script to ENABLE CrashReporter instead of disabling it
Flags:
  EOS
  # OPTIONS GO HERE
  cli.on('--quiet', '-q', 'Disable all script output.') { opts[:quiet] = true }
end.parse!

MODE = ARGV.shift # 'restore' will cause CrashReporter to be ENABLED

# There are three relevant plist files responsible for controlling CrashReporter:
# The root process only needs to be enabled/disabled once, and of course requires root access
ROOT_FILES = %w[/System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist]
# The user processes need to be restarted/disabled upon each login (see above links for source)
USER_FILES = %w[
  /System/Library/LaunchAgents/com.apple.ReportCrash.plist
  /System/Library/LaunchAgents/com.apple.ReportCrash.Self.plist
]

# A fast, reliable way to determine if ReportCrash is active is by checking the list of
# running daemons via the 'launchctl' utility (for both root and user)
SCAN_DAEMON_LIST = 'launchctl list | grep ReportCrash'
CRASH_REPORTER_IS_ENABLED = (system(SCAN_DAEMON_LIST) || system("sudo #{SCAN_DAEMON_LIST}")) ? true : false
ACTION = MODE.nil? ? :unload : :load # command to pass to launchctl

# If this fix is unnecessary, inform the user and then exit
if (MODE == 'restore' && CRASH_REPORTER_IS_ENABLED) || (MODE.nil? && !CRASH_REPORTER_IS_ENABLED)
  status = CRASH_REPORTER_IS_ENABLED ? :enabled : :disabled
  warn "WARNING: CrashReporter is already #{status}, so running this script may be unecessary!" unless opts[:quiet]
  exit
end

# This generates a command that when run via CLI, implements this fix for a single process.
# There are two necessary parts to solving a really out-of-control CrashReporter issue; it
# is not always enough to simply disable the Daemon config file, because if there is a
# program that is repeatedly crashing, for instance, it will trigger the immediate restart
# of the daemon, invalidating your attempt. This is a difficult situation, but there is at
# least one working solution (see the comment in function body for more detail).
#
# @see https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man1/launchctl.1.html
# @note Terminating CrashReporter via `killall CrashReporter` doesn't work in every case!
#
# @param [Pathname, String] file Plist configuration file for a single CrashReporter Daemon process
# @param [Symbol, String] cmd The command string passed to `launchctl`
# @param [String] prefix Optional string prepended to the final output, for instance 'sudo'
# @return [String] The command to be executed via CLI for given Daemon plist file
#
def cmd_str(file, cmd, prefix='')
  str = "launchctl #{cmd} -w #{file}" # the '-w' flag ensures the Plist file will be edited
  # If CrashReporter is stuck in an infinite loop, (continually being relaunched) there is
  # one very specific means of disabling it permanently, involving two calls to `launchctl`
  # WITHIN THE SAME COMMAND. The first step is to terminate the Daemon using the `stop`
  # subcommand, and IMMEDIATELY after it the `&&` operator must follow, connecting the next
  # expression which deactivates CrashReporter permanently via the `unload` subcommand.
  str.prepend "launchctl stop #{Pathname(file).basename '.plist'} && " if cmd == :unload
  prefix + str
end

# Run commands on each of the relevant Plist files
begin
  ROOT_DAEMONS_DISABLED = ROOT_FILES.each { |f| system cmd_str(f, ACTION, 'sudo ') }
  USER_DAEMONS_DISABLED = USER_FILES.each { |f| system cmd_str(f, ACTION) }
rescue e
  abort e
end

# Print results of the script, alerting user of any failures
if ROOT_DAEMONS_DISABLED && USER_DAEMONS_DISABLED
  unless opts[:quiet]
    puts 'CrashReporter was successfully disabled! Restart your computer in order for changes to take effect.'
    puts 'Note that you should run this script upon EVERY LOGIN to ensure CrashReporter is disabled!'
  end
else
  msg = 'ERROR: One or more of the following CrashReporter daemons were unable to be disabled:' + $/ + $/ + "\t"
  msg <<
    ROOT_FILES.join($/ + "\t") + $/ + 'Note that this script requires root access!' if ROOT_DAEMONS_DISABLED
    USER_FILES.join($/ + "\t") if USER_DAEMONS_DISABLED
  opts[:quiet] ? abort : abort(msg)
end
