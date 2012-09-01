module HockeyBrake
  class Configuration

    # The application bundle id
    attr_accessor :app_bundle_id

    # The app id of the application
    attr_accessor :app_id

    # The app version
    attr_accessor :app_version

    # The service url
    def hockey_url
      "https://rink.hockeyapp.net/api/2/apps/#{app_id}/crashes/upload"
    end

    # convert to hash
    def to_hash
      h = Hash.new
      h[:app_id] = self.app_id
      h[:app_version] = self.app_version
      h[:hockey_url] = self.hockey_url
      h
    end
  end
end