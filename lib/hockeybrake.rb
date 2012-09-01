require 'hockeybrake/configuration'
require 'hockeybrake/hockey_log'
require 'hockeybrake/hockey_sender'
require 'hockeybrake/hockey_sender_injector'

module HockeyBrake

  class << self

    def configure
      # receive the configuration
      yield(configuration)

      # check if we have resque support
      if self.configuration.no_resque_handler == false

        # Load optional modules for resque support and configure the resque handler for
        # us if needed
        begin
          require 'resque/failure/multiple'
          require 'resque/failure/airbrake'
          require 'resque/failure/redis'

          Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
          Resque::Failure.backend = Resque::Failure::Multiple
        rescue
          # nothing to do
        end

      end
    end

    def configuration
      @configuration ||= Configuration.new
    end

  end
end
