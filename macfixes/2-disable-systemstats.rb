#!/usr/bin/env ruby
#
# Mac fix 2 - Disable the `systemstats` daemon which can cause massive memory leaks in Mavericks
#
# In Mavericks, there is a system process called `systemstats` which sometimes runs out of
# control, eating up massive portions of CPU and memory. This fix disables it entirely.
#
# Resources:
# - http://osxdaily.com/2014/02/27/systemstats-cpu-use-slow-mac-os-x/
# - https://discussions.apple.com/message/23570188
# - http://www.codez4mac.com/forum/viewtopic.php?f=212&t=72198
# - https://discussions.apple.com/thread/5489959?start=15&tstart=0
# - http://www.guidingtech.com/30500/systemstats-hogging-cpu-stop/
#
# NOTE: THIS IS SUPER HACKY AT THE MOMENT, BUT IT WORKS
#
require 'pathname'

# Kill the process
`sudo killall systemstats`

# Backup the database
backup_dir = Pathname(Dir.home).join('.backup/systemstats').mkpath
backup_filename = backup_dir.join 'snapshot-', Time.now.strftime('%Y-%m-%d'), '.db'
`sudo mv /private/var/db/systemstats/snapshots.db #{backup_filename}`

# Daemon config files that control systemstats and run on startup
files = %w[
	com.apple.systemstatsd.plist
	com.apple.systemstats.daily.plist
	com.apple.systemstats.analysis.plist
]

# Disable or enable systemstats
disable = 'unload -w'
enable = 'load -F'
cmd = disable # set desired action
files.each { |file| `sudo launchctl #{cmd} #{File.join '/System/Library/LaunchDaemons/', file}` }

puts "The 'systemstats' daemon has been #{cmd}d."