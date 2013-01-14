class AECResponse
  def initialize doc
    puts doc
    @doc = doc
  end
  
  def confirmed?
    !@doc.css('#ctl00_ContentPlaceHolderBody_panelSuccess').empty?
  end
  
  def enrolled_address
    if confirmed?
      @doc.css('#ctl00_ContentPlaceHolderBody_labelAddress').text
    else
      ""
    end
  end
  
  def errors
    errors = @doc.css("table span.requiredtext:not([style*=\"display: none\"])").|(@doc.xpath('//h1[contains(text(), "Sorry, the entered security code could not be confirmed")]'))
    errors.map{|error| error.text}.reject{|error| error.include?("e.g.")}
  end
end

class AECParser < HTTParty::Parser
  SupportedFormats.merge!('text/html' => :html)

  def html
    AECResponse.new(Nokogiri::HTML(body))
  end
end

class EnrolmentCheck
  include HTTParty
  base_uri 'https://oevf.aec.gov.au'
  parser AECParser
  
  def initialize persons_details
    @persons_details = persons_details
  end
    
  def result(captcha_text, captcha_id, aec_cookies)
    options = {
      :body => {
        "__LASTFOCUS" => "",
        "ctl00_ContentPlaceHolderBody_ToolkitScriptManager1_HiddenField" => "",
        "__EVENTTARGET"=>"",
        "__EVENTARGUMENT"=>"",
        "__VIEWSTATE"=>"/wEPDwUJNDY5MTk1MTI1D2QWAmYPZBYEAgEPZBYCAhsPFgIeB2NvbnRlbnQFHENoZWNrIG15IGVsZWN0b3JhbCBlbnJvbG1lbnRkAgMPZBYGAgwPFgIeCWlubmVyaHRtbAUcQ2hlY2sgbXkgZWxlY3RvcmFsIGVucm9sbWVudGQCDg9kFgICAQ9kFgYCAw9kFgYCAQ8PFgIeC05hdmlnYXRlVXJsBTZodHRwOi8vd3d3LmFlYy5nb3YuYXUvRW5yb2xsaW5nX3RvX3ZvdGUvY2hlY2staGVscC5odG1kZAIDDw8WAh8CBTlodHRwOi8vd3d3LmFlYy5nb3YuYXUvQWJvdXRfQUVDL0NvbnRhY3RfdGhlX0FFQy9pbmRleC5odG1kZAIfDxBkZBYAZAIFDw8WAh4HVmlzaWJsZWhkFgQCBQ8PFgIfAgU5aHR0cDovL3d3dy5hZWMuZ292LmF1L0Fib3V0X0FFQy9Db250YWN0X3RoZV9BRUMvaW5kZXguaHRtZGQCBw8PFgIfAgVhaHR0cHM6Ly9zZWN1cmUuYWVjLmdvdi5hdS9PbmxpbmVGb3Jtcy9FbnJvbG1lbnQvVHJhY2tpbmc/ZklkPTgzMDU2MDQwLTA1MjUtNDc0NS1iYzkxLWEwNGQwMGExMWM1ZGRkAgcPDxYCHwNoZBYGAgMPZBYCAgEPDxYCHwIFOWh0dHA6Ly93d3cuYWVjLmdvdi5hdS9BYm91dF9BRUMvQ29udGFjdF90aGVfQUVDL2luZGV4Lmh0bWRkAgUPZBYCAgEPDxYCHwIFOWh0dHA6Ly93d3cuYWVjLmdvdi5hdS9BYm91dF9BRUMvQ29udGFjdF90aGVfQUVDL2luZGV4Lmh0bWRkAhEPDxYCHwIFLmh0dHA6Ly93d3cuYWVjLmdvdi5hdS9lbnJvbC9jaGFuZ2UtYWRkcmVzcy5odG1kZAITDw8WAh4EVGV4dAURMjAgU2VwdGVtYmVyIDIwMTJkZGQZieWTHmjSL+tpyMSN/mR1enJXQw==",
        "__EVENTVALIDATION"=>"/wEWHwKky9yaDwL2jZepBgK8uovuDgKkseu7BALM2qLBBwLl642+AgKQjeh+AoDR0PoBAp2Ano4PAsiElZcCAs3i0o4MAs3iso4MAp7RpJEPAsziio4MAsW3urgLAqS+5bsDArXXmc8EAvTizo4MArKF8Z0HArHR6PoBAuDi0o4MAv7i8o4MAv3ijo4MAv3iso4MAo3R7PoBArbXoc8EApCN6H4Cpanj8gkC042JpgoCivDVxQcC5NS6swgnASx9Pl1SpyX/oGSL59++ZbkjTQ==",
         "ctl00$ContentPlaceHolderBody$textSurname"=> @persons_details[:surname],
         "ctl00$ContentPlaceHolderBody$textGivenName"=> @persons_details[:given_names],
         "ctl00$ContentPlaceHolderBody$textFlatNumber"=> @persons_details[:flat_number],
         "ctl00$ContentPlaceHolderBody$textStreetNumber"=>@persons_details[:street_number],
         "ctl00$ContentPlaceHolderBody$textStreetName"=> @persons_details[:street_name],
         "ctl00$ContentPlaceHolderBody$comboStreetType"=> "", #we don't actually need to send this through just for the check
         "ctl00$ContentPlaceHolderBody$textPostcode"=> @persons_details[:postcode],
         "ctl00$ContentPlaceHolderBody$DropdownSuburb"=> @persons_details[:suburb],
         "LBD_VCID_verifyenrolment_ctl00_contentplaceholderbody_captchacode"=> captcha_id,
         "ctl00$ContentPlaceHolderBody$CaptchaCodeTextBox"=> captcha_text,
         "ctl00$ContentPlaceHolderBody$buttonVerify"=>" Verify Enrolment"
      },
      :headers => {
        "Cookie" => aec_cookies
      }
    }
    
    EnrolmentCheck.post("/VerifyEnrolment.aspx", options).parsed_response
  end
end