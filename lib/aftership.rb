$:.unshift File.dirname(__FILE__)

require 'aftership/v4/configuration'
require 'aftership/v4/courier'
require 'aftership/v4/tracking'
require 'aftership/v4/last_checkpoint'

module AfterShip
  class << self;
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= AfterShip::V4::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
