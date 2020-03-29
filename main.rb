require_relative 'lib/prime_now'
require_relative 'lib/sms_service'
require "dotenv/load"
require 'active_support/time'

merchant = ARGV[0]
abort('please specify a merchant. ex: ruby main.rb amazon') unless merchant

phone_number = ENV['PHONE_NUMBER']

prime_now = PrimeNow.new
sms_service = SmsService.new(phone_number)
available = false
while !available
  available = prime_now.check_delivery_availabilities(merchant)
  if available
    puts "There is an available slot"
    sms_service.send_sms(merchant)
  else
    puts "There is no available slot for #{merchant}"
    sleep(15.minutes)
  end
end