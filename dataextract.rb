# Load Ruby Gems

require 'yaml'
require 'rubygems'
require 'gmail'
require 'nokogiri' 
require 'selenium-webdriver'

# Pass File Into Script

filename = "urls.txt"

list = File.new(filename, "r")

arr = list.readlines

list.close


# Load Website To Test

driver = Selenium::WebDriver.for :firefox

emailbody = ""

#Looping The Website
#for urls in arr can also be used
arr.each do |urls|

driver.navigate.to "https://www.webpagetest.org"


# Input to Test Website

websiteurl = driver.find_element(:id, "url")

websiteurl.clear()

websiteurl.send_keys urls

# Click Button

SubmitButton = driver.find_element(:class, "start_test")

SubmitButton.click

# Timeout/Idle code then check for elements

wait = Selenium::WebDriver::Wait.new(:timeout => 300)

loadtime = wait.until {
    element = driver.find_element(:id, "LoadTime")
    element if element.displayed?
}

element = driver.find_element(:id, "TTFB")

puts "Test Passed" if loadtime && element
puts loadtime.text, element.text


emailbody = emailbody + "Values are #{loadtime.text}(Load Time), #{element.text}(First Byte), and is the website I used for #{urls}\n\n"

end


# Send Email

config = YAML.load_file("cred.yml")

gmail = Gmail.connect(config["config"]["email"], config["config"]["password"])

puts gmail.logged_in?

puts gmail.inbox.count

email = gmail.compose do
  to config["config"]["email"]
  subject "I did it!"
  body " #{emailbody} "
end
email.deliver!

gmail.logout

driver.quit





