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
    @person.organisation = params[:organisation]
   
    
    if (@result.confirmed?)
      @person.save if params[:mailinglist]
      render "confirmed"
    else
      flash[:person_details] = params[:person]
      flash[:suburb_autocomplete] = params[:suburb_autocomplete]
      if  @result.errors.empty?
        @person.save if params[:mailinglist]
        flash[:unconfirmed] = true
      else
        flash[:errors] = @result.errors
      end
      redirect_to :action => "show"
    end
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
    
  
end
