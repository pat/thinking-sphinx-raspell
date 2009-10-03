$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

require 'thinking_sphinx'
require 'raspell'
require 'thinking_sphinx/raspell'

Spec::Runner.configure do |config|
  #
end
