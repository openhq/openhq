require 'vcr'
require 'webmock'
require 'dotenv'

# Load env vars for kimono api key
Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
