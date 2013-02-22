# Load the rails application
require File.expand_path('../application', __FILE__)

YELP_CONSUMER_KEY = ENV['YELP_CONSUMER_KEY']
YELP_CONSUMER_SECRET = ENV['YELP_CONSUMER_SECRET']
YELP_TOKEN = ENV['YELP_TOKEN']
YELP_TOKEN_SECRET = ENV['YELP_TOKEN_SECRET']

APP_PAYPAL_CERT = File.read("#{Rails.root}/certs/smartvark_cert.pem")
APP_PAYPAL_KEY = File.read("#{Rails.root}/certs/smartvark_key.pem")
ActiveMerchant::Billing::PaypalGateway.pem_file = APP_PAYPAL_CERT

#Paperclip.options[:command_path] = `which convert`.chomp.gsub(/\/convert/,'') rescue "Something went wrong in config/environment.rb #{__LINE__}"

Phoner::Phone.default_country_code = '1'

MetaWhere.operator_overload!

# Initialize the rails application
Smartvark::Application.initialize!