require 'minitest/autorun'
require './lib/DUI.rb'
require 'hashie'

def new_record_with_id(id)
  Hashie::Mash.new :id => id
end

def new_record_with_id_and_email(id, email)
  Hashie::Mash.new :id => id, :email => email
end
