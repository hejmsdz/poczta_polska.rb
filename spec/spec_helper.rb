$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'poczta_polska'

def business_tracker
  username = ENV['POCZTA_USER']
  password = ENV['POCZTA_PASS']

  expect(username).not_to be_nil
  expect(password).not_to be_nil
  PocztaPolska.tracker(username, password)
end
