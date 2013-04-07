Smartvark::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  
  # Uncomment below to disable ActiveRecord logging
  # config.log_level = :info

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Don't send SMS except in production
  config.after_initialize do
    Moonshado::Sms.configure do |config|
      config.production_environment = false
    end
  end
  
  ActiveMerchant::Billing::Base.gateway_mode = :test
  ActiveMerchant::Billing::Base.integration_mode = :test
  PAYPAL_CERT = File.read("#{Rails.root}/certs/paypal_dev_cert.pem")
  PAYPAL_CERT_ID = "RW8PPYNCB6UF6"
  PAYPAL_EMAIL = "stefan_1307486076_biz@smartvark.com"
end

