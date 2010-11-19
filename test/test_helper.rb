ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  module Paperclip
    class Geometry
      def self.from_file file
        parse("100x100")
      end
    end
    class Thumbnail
      def make
        src = Test::FileHelper.fixture_file('white_pixel.jpg')
        dst = Tempfile.new([@basename, @format].compact.join("."))
        dst.binmode
        FileUtils.cp(src.path, dst.path)
        return dst
      end
    end
  end
end
