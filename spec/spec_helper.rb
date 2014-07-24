require 'caracal'
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.order = 'random'
end
