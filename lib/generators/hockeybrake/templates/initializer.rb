Airbrake.configure do |config|
  # comment out if sending exceptions in the development environment 
  # is needed as well
  # config.development_environments.delete("development")
end

HockeyBrake.configure do |config|

  # the bundle id
  config.app_bundle_id= "###YOUR BUNDLE IDENTIFIER FROM HOCKEYAPP###"

  # The application ID in hockey app
  config.app_id="###YOUR APP SECRET###"

  # The application version, you can use the different environments
  # as version, otherwise use the name of your version 
  config.app_version="#{Rails.env}"

end
