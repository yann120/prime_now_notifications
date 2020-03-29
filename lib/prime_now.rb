require 'selenium-webdriver'

class PrimeNow
  def initialize
    @driver = Selenium::WebDriver.for :safari
    @driver.manage.window.maximize
  end

  def check_delivery_availabilities(merchant)
    set_merchant(merchant)
    @driver.navigate.to("https://primenow.amazon.fr/checkout/enter-checkout?merchantId=#{@merchant_id}&ref=pn_sc_ptc_bwr")
    @driver.manage.timeouts.implicit_wait = 30
    enter_zip_code() if @driver.page_source.include? "Saisir votre code postal"
    login_user() if @driver.page_source.include? "S'identifier"
    !(@driver.page_source.include? "Tous les créneaux de livraison pour aujourd'hui et demain sont actuellement indisponibles.")
  end

  private

  def enter_zip_code
    unless zip_code = ENV['ZIP_CODE']
      print "please enter your zip code : "
      zip_code = STDIN.gets.chomp
    end
    form = @driver.find_element(:id, "locationSelectForm")
    form.find_element(:name, "lsPostalCode").send_keys(zip_code)
    form.submit
    sleep(10)
    @driver.navigate.to("https://primenow.amazon.fr/checkout/enter-checkout?merchantId=#{@merchant_id}&ref=pn_sc_ptc_bwr")
  end

  def login_user
    sleep(10)
    if ENV['AMAZON_EMAIL'] && ENV['AMAZON_PASSWORD']
      email = ENV['AMAZON_EMAIL']
      password = ENV['AMAZON_PASSWORD']
    else
      puts "You need to login first"
      print "please enter your amazon email : "
      email = STDIN.gets.chomp
      print "please enter your amazon password : "
      password = STDIN.gets.chomp
    end
    form = @driver.find_element(:name, "signIn")
    form.find_element(:name, "email").send_keys(email)
    form.find_element(:name, "password").send_keys(password)
    form.submit
    sleep(10)
  end

  def set_merchant(merchant)
    @merchant_id = case merchant
    when 'amazon'
      'AGMEOZFASZJSS'
    when 'monoprix'
      'A39IAEDNN88TCS'
    when 'truffaut'
      'A18F5OOOGLFI1K'
    when 'naturalia'
      'A14TQEU3FGQYTZ'
    else
      abort("You need to specify a valid merchant (amazon, monoprix, truffaut or naturalia)")
    end
  end
end