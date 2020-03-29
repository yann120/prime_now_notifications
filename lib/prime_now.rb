require 'selenium-webdriver'

class PrimeNow
  def initialize
    user_data_dir='/Users/yann/Library/Application Support/Google/Chrome/'
    chrome_profile='Profile 2'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--user-data-dir=#{user_data_dir}")
    options.add_argument("--profile-directory=#{chrome_profile}")
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def check_delivery_availabilities(merchant)
    merchant_id = set_merchant(merchant)
    @driver.navigate.to("https://primenow.amazon.fr/checkout/enter-checkout?merchantId=#{merchant_id}&ref=pn_sc_ptc_bwr")
    @driver.manage.timeouts.implicit_wait = 30
    enter_zip_code() if @driver.page_source.include? "Saisir votre code postal"
    click_login() if @driver.page_source.include? "Bonjour. Identifiez-vous"
    login_user() if @driver.page_source.include? "S'identifier"
    !(@driver.page_source.include? "Tous les créneaux de livraison pour aujourd'hui et demain sont actuellement indisponibles.")
  end

  private

  def enter_zip_code
    print "please enter your zip code : "
    zip_code = STDIN.gets.chomp
    form = @driver.find_element(:id, "locationSelectForm")
    form.find_element(:name, "lsPostalCode").send_keys(zip_code)
    form.submit
  end

  def click_login
    @driver.find_element(:href, "/account/address").click
  end

  def login_user
    puts "You need to login first"
    print "please enter your amazon email : "
    form = @driver.find_element(:name, "signIn")
    email = STDIN.gets.chomp
    form.find_element(:name, "email").send_keys(email)
    print "please enter your amazon password : "
    password = STDIN.gets.chomp
    form.find_element(:name, "password").send_keys(password)
    form.submit
  end

  def set_merchant(merchant)
    case merchant
    when 'amazon'
      'AGMEOZFASZJSS'
    when 'monoprix'
      'A39IAEDNN88TCS'
    when 'truffaut'
      'A18F5OOOGLFI1K'
    when 'naturalia'
      'A14TQEU3FGQYTZ'
    else
      abort("You need to specify a valid merchant")
    end
  end
end