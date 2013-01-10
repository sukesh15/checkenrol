class Person < ActiveRecord::Base
  attr_accessible :given_names, :postcode, :street_name, :suburb, :surname, :email
  SUBURB_STATE_REGEX = /(.*) \((.*)\)$/
  
  def locality
    SUBURB_STATE_REGEX.match(self.suburb)[1]
  end
  
  def state
    SUBURB_STATE_REGEX.match(self.suburb)[2]
  end
end
