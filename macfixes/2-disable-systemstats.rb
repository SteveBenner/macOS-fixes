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
#
# NOTE:
# - Temporarily fixed with:
#   $ sudo launchctl stop com.apple.systemstatsd
#   $ sudo launchctl stop com.apple.systemstats.periodic
#   $ sudo launchctl stop com.apple.systemstats.analysis
#   $ cd /Private/var/db/systemstats
#   $ sudo mv snapshots.db BACKUP_snapshots.db
#   do a manual reboot