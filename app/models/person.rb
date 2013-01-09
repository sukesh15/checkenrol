class Person < ActiveRecord::Base
  attr_accessible :given_names, :postcode, :street_name, :suburb, :surname
end
