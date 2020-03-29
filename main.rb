require_relative 'lib/prime_now'

merchant = ARGV[0]
abort('please specify a merchant. ex: ruby main.rb amazon') unless merchant

prime_now = PrimeNow.new
available = prime_now.check_delivery_availabilities(merchant)
if available
  puts "There is an available slot"
else
  puts "There is no available slot"
end