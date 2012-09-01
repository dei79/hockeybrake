# using multipart post
require 'net/http/post/multipart'

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

      # generate our time string
      dtstr = Time.now.strftime("%a %b %d %H:%M:%S %Z %Y")

      # store the data into temp file
      file = Tempfile.new('hockey-exception')
      file.write("Package: #{HockeyBrake.configuration.app_bundle_id}\n")
      file.write("Version: #{HockeyBrake.configuration.app_version}\n")
      file.write("Date: #{dtstr}\n");
      file.write("\n")
      file.write(data)
      file.close

      # buidl the url
      url = URI.parse(HockeyBrake.configuration.hockey_url)

      # send the request
      response = begin
        File.open(file.path) do |log|

          req = Net::HTTP::Post::Multipart.new url.path,
                                               "log" => UploadIO.new(log, 'application/octet-stream', "log.txt")
          Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
            http.request(req)
          end
        end
      rescue *HTTP_ERRORS => e
        log :error, "Unable to contact the HockeyApp server. HTTP Error=#{e}"
        nil
      end

      # remove the file
      file.unlink

      case response
        when Net::HTTPSuccess then
          log :info, "Success: #{response.class}", response
        else
          log :error, "Failure: #{response.class}", response
      end

      if response && response.respond_to?(:body)
        error_id = response.body.match(%r{<id[^>]*>(.*?)</id>})
        error_id[1] if error_id
      end
    rescue => e
      log :error, "[HockeyBrake::HockeySender#send_to_airbrake] Cannot send notification. Error: #{e.class} - #{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
      nil
    end
  end
end
