require 'spec_helper'

describe 'Hockeybrake configuration' do

  it 'accepts basic settings' do
    HockeyBrake.configure do |config|
      config.app_bundle_id= "com.test.app"
      config.app_id="secret"
      config.app_version="test"
    end

    HockeyBrake.configuration.app_bundle_id.should eq('com.test.app')
    HockeyBrake.configuration.app_id.should eq('secret')
    HockeyBrake.configuration.app_version.should eq('test')
  end

  it 'accepts resque specific settings' do
    HockeyBrake.configure do |config|
      config.no_resque_handler = true
    end

    HockeyBrake.configuration.no_resque_handler.should be_true
  end

end