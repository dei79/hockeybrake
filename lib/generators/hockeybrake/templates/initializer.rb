#
# This section contain the standard airbrake configuration and it should be used to manipulate everything
# what the execption handler can do for your. Airbrae API relevant things are ignored from the HockeyApp
# sender except proxy settings.
#
Airbrake.configure do |config|
  # comment out if sending exceptions in the development environment 
  # is needed as well
  # config.development_environments.delete("development")
end

#
# This section conains your hockeyapp configuration and should be used to set your HockeyApp relevant
# key and secrets.
#
HockeyBrake.configure do |config|

  # the bundle id
  config.app_bundle_id= "###YOUR BUNDLE IDENTIFIER FROM HOCKEYAPP###"

  # The application ID in hockey app
  config.app_id="###YOUR APP SECRET###"

  # The application version, you can use the different environments
  # as version, otherwise use the name of your version 
  config.app_version="#{Rails.env}"

  # Support for resque exception handling is enabled by default. Wit this
  # settings the resque support will be disabled. If no resque gem is installed
  # it will be disabled automatically
  # config.no_resque_handler = true

end
