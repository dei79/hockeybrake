require 'spec_helper'
require 'spec_hockeybrake_configuration'

describe 'HockeyLog Exception Tracing' do
  it 'trace standard exception' do
    begin
      raise "This is a sample exception"
    rescue
      notice = Airbrake.send(:build_notice_for, $!)
      HockeyBrake::HockeyLog.generate(notice)
    end
  end

  it 'raise specific exception when trace failed' do
    expect {
      HockeyBrake::HockeyLog.generate("Not a good exception")
    }.to raise_exception(HockeyBrake::HockeyLogException) do |error|
      error.message.should start_with("An exception was thrown during handling of the exception from the HockeyBrake injector")
    end
  end
end





