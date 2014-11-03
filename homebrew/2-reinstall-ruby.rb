#!/usr/bin/env ruby
#
# 
# 
# @author Stephen Benner
# https://github.com/SteveBenner
#
require 'optparse'

# Default options
opts = {
	
}
# Command line interface
optparser = OptionParser.new do |cli|
  cli.version = '0.0.1'
	cli.summary_width  = 24
	cli.summary_indent = ' ' * 2
	cli.banner = ''
	# OPTIONS GO HERE
	cli.on_tail('-h', '--help', '--usage', 'Display this message.') { puts cli; exit }
  cli.on_tail('--version', 'Display script version.') { puts opts.version; exit }
end.parse!
