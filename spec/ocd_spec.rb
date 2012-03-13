require 'rubygems'
require 'logger'

require_relative '../lib/ocd'

describe OCD do
  it 'should initialize properly' do
    @ocd = OCD.new(:debug => true)
    # throws no errors
  end

  it 'should handle a release filename' do
    @ocd = OCD.new({})
    ep = @ocd.extract_episode('Show.Name.S03E08.PROPER.HDTV.x264-COMPULSiON.mp4')
    ep.should_not be_nil
    ep[:show_name].should == 'Show.Name'
    ep[:season].should == 3
    ep[:episode].should == 8
  end

  it 'should handle a tvnamer filename' do
    @ocd = OCD.new({})
    ep = @ocd.extract_episode('That One Show - [04x16] - That One Episode.mp4')
    ep.should_not be_nil
    ep[:show_name].should == 'That One Show'
    ep[:season].should == 4
    ep[:episode].should == 16
  end

  it 'should handle a tvnamer filename with a year' do
    @ocd = OCD.new({})
    ep = @ocd.extract_episode('That One Show - [2012-04-01] - That One Episode.mp4')
    ep.should_not be_nil
    ep[:show_name].should == 'That One Show'
    ep[:season].should == 4
    ep[:episode].should == 1
  end
end
