require 'spec_helper'
describe Person do
  
  describe ".locality" do
    it "should return the correct locality from suburb information" do
      person = Person.new(:suburb => "Elwood (VIC)")
      expect(person.locality).to eq("Elwood")
    end
    it "should return the correct state from suburb information" do
      person = Person.new(:suburb => "Elwood (VIC)")
      expect(person.state).to eq("VIC")
    end
  end
end