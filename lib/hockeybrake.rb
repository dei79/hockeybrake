require 'hockeybrake/configuration'
require 'hockeybrake/hockey_log_exception'
require 'hockeybrake/hockey_log'
require 'hockeybrake/hockey_sender'
require 'hockeybrake/hockey_sender_injector'

module HockeyBrake

  class << self

    def configure
      # receive the configuration
      yield(configuration)

      # check if we have resque support
      unless self.configuration.no_resque_handler

        # Load optional modules for resque support and configure the resque handler for
        # us if needed
        begin
          require 'resque/failure/multiple'
          require 'resque/failure/airbrake'
          require 'resque/failure/redis'

          Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
          Resque::Failure.backend = Resque::Failure::Multiple
        rescue LoadError
          # No resquem it's ok
        end

      end

      # check if we have sidekiq support
      unless self.configuration.no_sidekiq_handler
        begin
          Sidekiq.configure_server do |config|
            config.error_handlers << Proc.new { |ex,ctx_hash|
              ::Airbrake.notify_or_ignore(ex, :parameters => ctx_hash)
            }
          end
        end
      end
    end

    def configuration
      @configuration ||= Configuration.new
    end

  end
end
