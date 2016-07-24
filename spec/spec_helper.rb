require 'pry'
require 'rspec/expectations'
require 'simplecov'
require 'rest-client'
require 'poisol'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start

RSpec.configure do |config|

  config.before(:each) do
    Poisol.reset_data
  end

  config.before(:suite) do
    Poisol.start
    Poisol.load "spec/data/main/"
    Poisol.load "spec/data/domain/first/"
    Poisol.load "spec/data/domain/second/"
  end

  config.after(:suite) do
    Poisol.stop
  end

end
