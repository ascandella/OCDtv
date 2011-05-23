#!/usr/bin/env ruby

require 'fileutils'

require 'rubygems'
require 'yaml'
require 'logger'
require 'trollop'

require File.join(File.dirname(__FILE__), 'lib/ocd')
COMMANDS = %w(scan dryrun)

opts = Trollop::options do
  banner <<-EOS
usage: #{__FILE__} <command> [options]

Probably helpful if you know what the commands are:

   scan       Do the damn thing
   dryrun     Don't actually move anything

global options:
EOS
  opt :config,    "Load configuration from this file",
      :default => File.join( File.dirname(__FILE__), 'config.yml')
  opt :debug,     "Print more output",
      :default => false
  stop_on COMMANDS
end

Trollop::die :config, "must exist" unless File.exist?(opts[:config])
config = YAML::load(File.open(opts[:config]))

cmd = ARGV.shift
dry_run = (cmd == 'dryrun')

sweeper = OCD.new(config, opts)
sweeper.scan(dry_run)
