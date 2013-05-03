require "spec_helper"

describe "Electoral enrolment" do

  let (:captcha) do
    CaptchaImage.new({:headers => {"Set-Cookie" => "ASP.NET_SessionId=lpaes1455axe1xjjqbi5va55; path=/; HttpOnly"}})
  end

  let (:session) do
    {
        :captcha_id => captcha.captcha_id,
        :aec_cookies => captcha.cookies
    }
  end
  let (:person_input ) do
    {
        :surname => "Kumar",
        :given_names => "Sukesh",
        :street_name => "Pitt Street",
        :postcode => "2000",
        :suburb => "CBD"

    }
  end
  let(:params) { {:person => person_input ,:captcha => {}} }
  let(:check) { EnrolmentCheck.new(params[:person]) }
  let(:result) { check.result(params[:captcha], session[:captcha_id], session[:aec_cookies]) }

  xit "should check for enrolment of a person" do
    puts result.errors
    result.errors.should be_empty
  end



end