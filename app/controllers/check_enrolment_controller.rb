class CheckEnrolmentController < ApplicationController
    
  def show
    @person = Person.new(flash[:person_details])
    @captcha_image = CaptchaImage.new
    session[:aec_cookies] = @captcha_image.cookies
    session[:captcha_id] = @captcha_image.captcha_id
  end
  
  
  def update
     @person = Person.find_by_id(params[:person][:id])
     #update the person if they are in the DB
     if @person
       @person.update_attributes(params[:person])
       @person.save
     else
       @person = Person.new(params[:person]) unless @person
     end
  end
  
  def check
    check = EnrolmentCheck.new(params[:person])
    @result = check.result(params[:captcha], session[:captcha_id] , session[:aec_cookies])
    @person = Person.new(params[:person])
    
    @person.save if params[:mailinglist] && !@person.email.blank?
    
    if (@result.confirmed?)
      render "confirmed"
    else
      flash[:person_details] = params[:person]
      flash[:suburb_autocomplete] = params[:suburb_autocomplete]
      if  @result.errors.empty?
        flash[:unconfirmed] = true
      else
        flash[:errors] = @result.errors
      end
      redirect_to :action => "show"
    end
  end
    
  
end
