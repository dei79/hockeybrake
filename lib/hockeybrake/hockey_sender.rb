# using multipart post
require 'net/http/post/multipart'
require 'airbrake'

module HockeyBrake
  # Sends out the notice to HockeyApp
  class HockeySender < Airbrake::Sender

    # initialize the sender
    def initialize
      super(Airbrake.configuration.to_hash)
    end

    # Sends the notice data off to HockeyApp for processing.
    #
    # @param [String] data The XML notice to be sent off
    def send_to_airbrake(data)

      # generate the log
      logstr = HockeyLog.generate_safe(data)

      # generate the stirng io
      logio = StringIO.new(logstr)

      # buidl the url
      url = URI.parse(HockeyBrake.configuration.hockey_url)

      # send the request
      response = begin

                   # build the request
        req = Net::HTTP::Post::Multipart.new( url.path, "log" => UploadIO.new(logio, 'application/octet-stream', "log.txt") )

        # start the upload
        Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
          http.request(req)
        end

      rescue *HTTP_ERRORS => e
        log_internal  :level => :error, :message => "Unable to contact the HockeyApp server. HTTP Error=#{e}"
        nil
      end

      case response
        when Net::HTTPSuccess then
          log_internal  :level => :info, :message => "Success: #{response.class}", :response => response
        else
          log_internal  :level => :error, :message => "Failure: #{response.class}", :response => response
      end

      if response && response.respond_to?(:body)
        error_id = response.body.match(%r{<id[^>]*>(.*?)</id>})
        error_id[1] if error_id
      end
    rescue Exception => e
      log_internal  :level => :error,  :message => "[HockeyBrake::HockeySender#send_to_airbrake] Cannot send notification. Error: #{e.class} - #{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
      nil
    end

    def log_internal(options = {})
      log options
    rescue
      log options[:level], options[:message], options[:response]
    end
  end
end
