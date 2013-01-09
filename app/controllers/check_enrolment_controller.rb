class CheckEnrolmentController < ApplicationController
    
  def show
    @captcha_image = CaptchaImage.new
    session[:aec_cookies] = @captcha_image.cookies
    session[:captcha_id] = @captcha_image.captcha_id
  end
  
  def check
    #EnrolmentCheck.new(params[:person])
    check = EnrolmentCheck.new({:surname => "Fowler", :given_names => "Perryn", :street_name => "St Kilda", :postcode => "3184", :suburb => "ELWOOD (VIC)"})
    render :inline => check.result(params[:captcha], session[:captcha_id] , session[:aec_cookies])
  end
    
  
end
