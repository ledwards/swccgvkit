Swccgvkit::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  config.active_support.deprecation = :stderr

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
    
  Paperclip.options[:command_path] = "/opt/local/bin"
  Paperclip.options[:swallow_stderr] = false
  
  config.s3_bucket = "ledwards-swccgvkit-test"
  
  config.vslip_image_import_path = "#{Rails.root}/../shared/vslips"
  config.card_image_import_path = "#{Rails.root}/../shared/cards"

  Capybara.default_wait_time = 10  

  config.after_initialize do
    WICKED_PDF[:exe_path] = "/usr/local/bin/wkhtmltopdf"
    ActionController::Base.asset_host = Proc.new do |source, request|
      if request.format == 'pdf'
        "http://#{Rails.root.join('public')}"
      end
    end
  end
end
