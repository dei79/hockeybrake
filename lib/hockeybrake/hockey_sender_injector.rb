module HockeyBrake
  module HockeySenderInjector
    def override_send_to_airbrake(data)
      HockeyBrake::HockeySender.new().send_to_airbrake(data)
    end
  end
end

module Airbrake
  class Sender
    include HockeyBrake::HockeySenderInjector
    alias_method :send_to_airbrake, :override_send_to_airbrake
  end
end