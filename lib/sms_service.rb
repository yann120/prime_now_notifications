require 'telerivet'

class SmsService
  def initialize(recipient_number)
    tr = Telerivet::API.new(ENV['TELERIVET_API_KEY'])
    @telerivet = tr.init_project_by_id(ENV['TELERIVET_PROJECT_ID'])
    if (recipient_number).empty?
      print "Please enter your phone number to get notify : "
      recipient_number = STDIN.gets.chomp
    end
    @recipient_number = recipient_number
  end
  
  def send_sms(merchant)
    @telerivet.send_message({
      'content' => "There is delivery slots available on Prime now for the merchant #{merchant}",
      'to_number' => @recipient_number
    })
  end
end