module HockeyBrake
  class HockeyLogException < Exception
    attr_accessor(:innerexception)

    def initialize(exception)
      @innerexception = exception
    end

    def message()
      "An exception was thrown during handling of the exception from the HockeyBrake injector\n" +
      "Exception: #{@innerexception.message}"
    end
  end
end
