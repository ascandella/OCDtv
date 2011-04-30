#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'hashie'
require 'fileutils'

require './lib/ocd.rb'

config = File.open(
  File.join(File.dirname(__FILE__), 'config.yml')) do |yam|
  Hashie::Mash.new(YAML::load(yam))
end

sweeper = OCD.new(config)
sweeper.scan
