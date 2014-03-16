require 'active_support/core_ext'

#
# This class converts the given Airbrake XML data to the log format of the HockeyApp server
#
module HockeyBrake
  class HockeyLog

    #
    # Generates a string which can be sent to the hockey service
    def self.generate_safe(data)
      begin
        output = HockeyLog.generate(data)
      rescue HockeyBrake::HockeyLogException => e
        output += e.message
      end

      # go ahead
      output
    end

    #
    # Generates a string which can be sent to the hockey service
    def self.generate(data)
      begin
        # the output
        output = ""

        # generate our time string
        dtstr = Time.now.strftime("%a %b %d %H:%M:%S %Z %Y")

        # write the header so that we have something to send
        output += "Package: #{HockeyBrake.configuration.app_bundle_id}\n"
        output += "Version: #{HockeyBrake.configuration.app_version}\n"
        output += "Date: #{dtstr}\n"

        # add the optional values if possible
        begin
          output += "Android: #{RUBY_PLATFORM}\n"
          output += "Model: Ruby #{RUBY_VERSION} Rails #{Rails.version}\n"
        rescue
          # nothing to do
        end

        # add the empty line
        output += "\n"

        # parse the XML and convert them to the HockeyApp format
        if ( data.is_a?(String))
          output += generate_from_xml(data)
        else
          output += generate_from_notice(data)
        end

        # return the output
        output
      rescue Exception => e
        raise HockeyLogException.new(e)
      end
    end

    def self.generate_from_notice(data)
      output = ""

      # write the first line
      output += "#{data.error_class}: #{data.error_message}\n"

      # generate the call stacke
      data.backtrace.lines.each do |line|
        class_name =   File.basename(line.file, ".rb").classify

        begin
          output += "    at #{class_name}##{line.method}(#{line.file}:#{line.number})\n"
        rescue
          output += "    at #{class_name}##{line.method_name}(#{line.file}:#{line.number})\n"
        end
      end

      # emit
      output
    end

    def self.generate_from_xml(data)
      # the output
      output = ""

      # xml parser
      crashData = Hash.from_xml(data)

      # write the first line
      output += "#{crashData['notice']['error']['class']}: #{crashData['notice']['error']['message']}\n"

      # parse the lines
      lines = crashData['notice']['error']['backtrace']['line']
      lines.each do |line|
        class_name =   File.basename(line['file'], ".rb").classify
        output += "    at #{class_name}##{line['method']}(#{line['file']}:#{line['number']})\n"
      end

      # emit
      output
    end
  end

end