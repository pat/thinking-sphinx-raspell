require 'rubygems'
require 'bundler'
require 'logger'

$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__) + '/..'

require 'thinking_sphinx/raspell'

ThinkingSphinx::ActiveRecord::LogSubscriber.logger = Logger.new(StringIO.new)

RSpec.configure do |config|
  #
end
