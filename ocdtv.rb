#!/usr/bin/env ruby

require 'fileutils'

require 'rubygems'
require 'yaml'
require 'hashie'
require 'logger'

require './lib/ocd.rb'

config = YAML::load(File.open(File.join(
  File.dirname(__FILE__), 'config.yml')))

sweeper = OCD.new(config)
sweeper.scan
