require 'hockeybrake/configuration'
require 'hockeybrake/hockey_log'
require 'hockeybrake/hockey_sender'
require 'hockeybrake/hockey_sender_injector'

module HockeyBrake

  class << self

    def configure
      # receive the configuration
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

  end
end
