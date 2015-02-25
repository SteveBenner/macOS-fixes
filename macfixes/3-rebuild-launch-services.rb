#!/usr/bin/env ruby
#
# Mac fix 3 - Rebuild the launch services database
#
# This is a simple maintenance command which can solve the following issues:
#
# 1. The mac App Store can become corrupted in such a way that
#    previously-installed apps will show up as 'installed' in the 'purchases'
#    screen, even if they don't exist on the machine. This prevents them from
#    being re-installed, obviously.
#
# NOTE: This script requires root access, so it might be necessary to use 'sudo' when executing it
#
# Resources:
# - stack exchange thread:
#   http://apple.stackexchange.com/questions/7075/how-can-i-reinstall-an-application-that-the-mac-app-store-thinks-is-installed-al
# - MacLife article explaining the benefits of this maintenance:
#   http://www.maclife.com/article/howtos/how_rebuild_launchservices_remove_duplicates_open_menu
# - possible alternate solution:
#   http://superuser.com/questions/437708/how-to-re-install-an-app-that-shows-up-in-the-appstore-as-update-instead-of-b

# Kill the launch services processes, effectively resetting the database
PROGRAM = '/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
ARGS = ['-kill']

` -kill -r -domain local -domain system -domain user`

# another command to reset launch services
# /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed -r -domain all
