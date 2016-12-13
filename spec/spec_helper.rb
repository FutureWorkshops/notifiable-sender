require 'webmock/rspec'
require 'byebug'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'notifiable/sender'

# WebMock setup
WebMock.disable_net_connect!

