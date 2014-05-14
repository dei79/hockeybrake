module HockeyBrake
  class Configuration

    # The application bundle id
    attr_accessor :app_bundle_id

    # The app id of the application
    attr_accessor :app_id

    # The app version
    attr_accessor :app_version

    # Allow to disable resque support
    attr_accessor :no_resque_handler

    # Allow to disable sidekiq suppoer
    attr_accessor :no_sidekiq_handler


    # The service url
    def hockey_url
      "https://rink.hockeyapp.net/api/2/apps/#{app_id}/crashes/upload"
    end

    # ctor
    def initialize
      # resque is enable by default
      self.no_resque_handler = false
    end

    # convert to hash
    def to_hash
      h = Hash.new
      h[:app_id] = self.app_id
      h[:app_version] = self.app_version
      h[:hockey_url] = self.hockey_url
      h[:no_resque_handler] = self.no_resque_handler
      h
    end
  end
end