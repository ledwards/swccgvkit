# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spec/support/fixture_builder.rb'
require 'factory_girl'
Factory.find_definitions

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  module Paperclip
    class Geometry
      def self.from_file file
        parse("100x100")
      end
    end
    class Thumbnail
      def make
        src = URI.parse("#{Rails.root}/spec/fixtures/test.jpg")
        dst = Tempfile.new([@basename, @format].compact.join("."))
        dst.binmode
        FileUtils.cp(src.path, dst.path)
        return dst
      end
    end
  end

  def online?
    begin
      Net::HTTP.get URI.parse('http://www.google.com/')
      val = true
    rescue
      val = false
    end
    return val
  end
  
  puts "*** No Internet Connection ***" unless online?

end
