class CheckEnrolmentController < ApplicationController
  include HTTParty
  base_uri 'https://oevf.aec.gov.au'
    
  def show
    @captcha_image = CaptchaImage.new
    session[:aec_cookies] = @captcha_image.cookies
    session[:captcha_id] = @captcha_image.captcha_id
  end
  
  def check
    options = {
      :body => {
        "__LASTFOCUS" => "",
        "ctl00_ContentPlaceHolderBody_ToolkitScriptManager1_HiddenField" => "",
        "__EVENTTARGET"=>"",
        "__EVENTARGUMENT"=>"",
        "__VIEWSTATE"=>"/wEPDwUJNDY5MTk1MTI1D2QWAmYPZBYEAgEPZBYCAhsPFgIeB2NvbnRlbnQFHENoZWNrIG15IGVsZWN0b3JhbCBlbnJvbG1lbnRkAgMPZBYGAgwPFgIeCWlubmVyaHRtbAUcQ2hlY2sgbXkgZWxlY3RvcmFsIGVucm9sbWVudGQCDg9kFgICAQ9kFgYCAw9kFgYCAQ8PFgIeC05hdmlnYXRlVXJsBTZodHRwOi8vd3d3LmFlYy5nb3YuYXUvRW5yb2xsaW5nX3RvX3ZvdGUvY2hlY2staGVscC5odG1kZAIDDw8WAh8CBTlodHRwOi8vd3d3LmFlYy5nb3YuYXUvQWJvdXRfQUVDL0NvbnRhY3RfdGhlX0FFQy9pbmRleC5odG1kZAIfDxBkZBYAZAIFDw8WAh4HVmlzaWJsZWhkFgQCBQ8PFgIfAgU5aHR0cDovL3d3dy5hZWMuZ292LmF1L0Fib3V0X0FFQy9Db250YWN0X3RoZV9BRUMvaW5kZXguaHRtZGQCBw8PFgIfAgVhaHR0cHM6Ly9zZWN1cmUuYWVjLmdvdi5hdS9PbmxpbmVGb3Jtcy9FbnJvbG1lbnQvVHJhY2tpbmc/ZklkPTgzMDU2MDQwLTA1MjUtNDc0NS1iYzkxLWEwNGQwMGExMWM1ZGRkAgcPDxYCHwNoZBYGAgMPZBYCAgEPDxYCHwIFOWh0dHA6Ly93d3cuYWVjLmdvdi5hdS9BYm91dF9BRUMvQ29udGFjdF90aGVfQUVDL2luZGV4Lmh0bWRkAgUPZBYCAgEPDxYCHwIFOWh0dHA6Ly93d3cuYWVjLmdvdi5hdS9BYm91dF9BRUMvQ29udGFjdF90aGVfQUVDL2luZGV4Lmh0bWRkAhEPDxYCHwIFLmh0dHA6Ly93d3cuYWVjLmdvdi5hdS9lbnJvbC9jaGFuZ2UtYWRkcmVzcy5odG1kZAITDw8WAh4EVGV4dAURMjAgU2VwdGVtYmVyIDIwMTJkZGQZieWTHmjSL+tpyMSN/mR1enJXQw==",
        "__EVENTVALIDATION"=>"/wEWHwKky9yaDwL2jZepBgK8uovuDgKkseu7BALM2qLBBwLl642+AgKQjeh+AoDR0PoBAp2Ano4PAsiElZcCAs3i0o4MAs3iso4MAp7RpJEPAsziio4MAsW3urgLAqS+5bsDArXXmc8EAvTizo4MArKF8Z0HArHR6PoBAuDi0o4MAv7i8o4MAv3ijo4MAv3iso4MAo3R7PoBArbXoc8EApCN6H4Cpanj8gkC042JpgoCivDVxQcC5NS6swgnASx9Pl1SpyX/oGSL59++ZbkjTQ==",
         "ctl00$ContentPlaceHolderBody$textSurname"=>"Fowler",
         "ctl00$ContentPlaceHolderBody$textGivenName"=>"Perryn",
         "ctl00$ContentPlaceHolderBody$textFlatNumber"=>"",
         "ctl00$ContentPlaceHolderBody$textStreetNumber"=>"",
         "ctl00$ContentPlaceHolderBody$textStreetName"=>"St Kilda",
         "ctl00$ContentPlaceHolderBody$comboStreetType"=>"",
         "ctl00$ContentPlaceHolderBody$textPostcode"=>"3184",
         "ctl00$ContentPlaceHolderBody$DropdownSuburb"=>"ELWOOD (VIC)",
         "LBD_VCID_verifyenrolment_ctl00_contentplaceholderbody_captchacode"=> session[:captcha_id],
         "ctl00$ContentPlaceHolderBody$CaptchaCodeTextBox"=> params[:captcha],
         "ctl00$ContentPlaceHolderBody$buttonVerify"=>" Verify Enrolment"
      },
      :headers => {
        "Cookie" => session[:aec_cookies]
      }
    }   
    puts "************"
    puts params[:captcha] 
    puts "************"
    render :inline => CheckEnrolmentController.post('/VerifyEnrolment.aspx', options)
  end
    
  
end
