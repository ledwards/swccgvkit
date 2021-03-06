Swccgvkit::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  #Deprecation warnings
  config.active_support.deprecation :log

  #Paperclip.options[:command_path] = "/opt/local/bin" # useful for some OS X installations of ImageMagick (identify)
  Paperclip.options[:swallow_stderr] = false

  config.s3_bucket = "ledwards-swccgvkit-development"

  config.vslip_image_import_path = "#{Rails.root}/../shared/vslips"
  config.card_image_import_path = "#{Rails.root}/../shared/cards"

  config.after_initialize do
    WICKED_PDF[:exe_path] = "/usr/local/bin/wkhtmltopdf"
    ActionController::Base.asset_host = Proc.new do |source, request|
      if request.format == 'pdf'
        "http://#{Rails.root.join('public')}"
      end
    end
  end
end
