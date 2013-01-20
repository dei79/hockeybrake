Airbrake.configure do |config|
  config.development_environments.delete("test")
end

HockeyBrake.configure do |config|
  config.app_bundle_id= "com.test.app"
  config.app_id="secret"
  config.app_version="test"
end