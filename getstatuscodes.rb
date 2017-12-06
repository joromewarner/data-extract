require 'yaml'
require 'rubygems'
require 'gmail'
require 'nokogiri' 
require 'selenium-webdriver'
require 'crack'
require 'net/http'
require 'open-uri'

class Url_checker
  def get_status_code

    # Read in Files

    filename = "urls.txt"

    list = File.new(filename, "r")

    websites_from_file = list.readlines

    list.close

    # Loop Websites

    websites_from_file.each do |websites|
      begin
        res = Net::HTTP.get_response(URI.parse(URI.encode(websites.strip)))
        puts res.code

        success_urls = []
        failed_urls = []

        case res.code
          when "200"
            success_urls.push
          when "404"
            failed_urls.push
          else
            puts "fail"
          end
      # Catch Exceptions
      
      rescue Exception => error
        puts "Malformed Error"
      end
    end
  end
end




status_codes = Url_checker.new

status_codes.get_status_code

