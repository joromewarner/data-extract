# Load Ruby Gems

require 'yaml'
require 'rubygems'
require 'gmail'
require 'nokogiri' 
require 'selenium-webdriver'

# Load Website To Test

urls = "https://www.webpagetest.org"
driver = Selenium::WebDriver.for :firefox
driver.navigate.to "#{urls}"

# Input to Test Website

url = "https://www.Joshuakemp.blogspot.com"
websiteurl = driver.find_element(:id, "url")
websiteurl.clear()
websiteurl.send_keys "#{url}"

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

# Send Email
config = YAML.load_file("cred.yml")

gmail = Gmail.connect( config["config"]["email"], config["config"]["password"])

puts gmail.logged_in?

puts gmail.inbox.count

email = gmail.compose do
  to config["config"]["to"]
  subject "I did it!"
  body "Values are #{loadtime.text}(Load Time), #{element.text}(First Byte), and #{url} is the website I used for the web page test." 
end
email.deliver!

gmail.logout

driver.quit





