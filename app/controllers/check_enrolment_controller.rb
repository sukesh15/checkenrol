class CheckEnrolmentController < ApplicationController
    
  def show
    @person = Person.new(flash[:person_details])
    @captcha_image = CaptchaImage.new
    session[:aec_cookies] = @captcha_image.cookies
    session[:captcha_id] = @captcha_image.captcha_id
  end
  
  def check
    check = EnrolmentCheck.new(params[:person])
    @result = check.result(params[:captcha], session[:captcha_id] , session[:aec_cookies])
    @person = Person.new(params[:person])
    
    @person.save if params[:mailinglist]
    
    if (@result.confirmed?)
      render "confirmed"
    else
      flash[:person_details] = params[:person]
      puts params[:autocomplete]
      flash[:autocomplete] = params[:autocomplete]
      if  @result.errors.empty?
        flash[:unconfirmed] = true
      else
        flash[:errors] = @result.errors
      end
      redirect_to :action => "show"
    end
  end
    
  
end
