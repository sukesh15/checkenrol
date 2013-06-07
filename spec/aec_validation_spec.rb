require "spec_helper"


describe "enrolment check validations" do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = ENV['CHECKENROL_URL'] || "https://testcheckenrol.herokuapp.com/"

    @driver.manage.timeouts.implicit_wait = 30
  end

  after(:each) do
    @driver.quit
  end

  it "should throw expected validation errors for a blank form submit " do
    @driver.get(@base_url + "/")
    @driver.find_element(:name, "commit").click

    @elements = @driver.find_elements(:class, "alert-error")

    errors = Array.new

    for element in @elements
      errors.push element.text.split("\n").last
    end

    expected_errors = ["Please enter your surname" ,
    "Please enter given names",
    "Please enter your postcode",
    "Please enter a valid postcode",
    "Please enter the verification code",
    "Sorry, the entered security code could not be confirmed"]

    errors.count.should == expected_errors.size
    expected_errors.should =~ errors
  end
end
