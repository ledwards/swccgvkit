require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :none }
end
