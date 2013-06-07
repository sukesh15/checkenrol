class AECResponse
  def initialize doc
    @doc = doc
  end

  def confirmed?
    !@doc.css('#ctl00_ContentPlaceHolderBody_panelSuccess').empty?
  end

  def system_error?
    !@doc.xpath('//h2[contains(text(), "System Problem")]').empty?
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
        "__VIEWSTATE"=>"/wEPDwUKLTc0NjM3MDQ2NQ9kFgJmD2QWBAIBD2QWAgIUDxYCHgdjb250ZW50BRJDaGVjayBteSBlbnJvbG1lbnRkAgMPZBYIAgwPFgIeCWlubmVyaHRtbAUSQ2hlY2sgbXkgZW5yb2xtZW50ZAIOD2QWAgIBD2QWBgIDD2QWBmYPDxYCHgtOYXZpZ2F0ZVVybAU5aHR0cDovL3d3dy5hZWMuZ292LmF1L0Fib3V0X0FFQy9Db250YWN0X3RoZV9BRUMvaW5kZXguaHRtZGQCAQ8PFgIfAgU2aHR0cDovL3d3dy5hZWMuZ292LmF1L0Vucm9sbGluZ190b192b3RlL2NoZWNrLWhlbHAuaHRtZGQCCg8QZGQWAGQCBQ8PFgIeB1Zpc2libGVoZBYEAgcPDxYCHwIFOWh0dHA6Ly93d3cuYWVjLmdvdi5hdS9BYm91dF9BRUMvQ29udGFjdF90aGVfQUVDL2luZGV4Lmh0bWRkAgsPZBYCAgEPDxYCHwIFYWh0dHBzOi8vc2VjdXJlLmFlYy5nb3YuYXUvT25saW5lRm9ybXMvRW5yb2xtZW50L1RyYWNraW5nP2ZJZD04MzA1NjA0MC0wNTI1LTQ3NDUtYmM5MS1hMDRkMDBhMTFjNWRkZAIHDw8WAh8DaGQWAgIRD2QWAgIBDw8WAh8CBS5odHRwOi8vd3d3LmFlYy5nb3YuYXUvZW5yb2wvY2hhbmdlLWFkZHJlc3MuaHRtZGQCEA8PFgIeBFRleHQFDDA2IEp1bmUgMjAxM2RkAhUPDxYCHwQFDDA0IEp1bmUgMjAxM2RkZA+DveQzmgo5ZRCnbSQllDRrKRaC",
        "__EVENTVALIDATION"=>"/wEWCALg2JyIBQK8uovuDgL2jZepBgKlqePyCQLl642+AgKU6uOkAwKK8NXFBwLk1LqzCAPQieUycRjMdK8YHibz+nanMz6S",
         "ctl00$ContentPlaceHolderBody$textSurname"=> @persons_details[:surname],
         "ctl00$ContentPlaceHolderBody$textGivenName"=> @persons_details[:given_names],
         "ctl00$ContentPlaceHolderBody$textStreetName"=> @persons_details[:street_name],
         "ctl00$ContentPlaceHolderBody$comboStreetType"=> "", #we don't actually need to send this through just for the check
         "ctl00$ContentPlaceHolderBody$textPostcode"=> @persons_details[:postcode],
         "ctl00$ContentPlaceHolderBody$DropdownSuburb"=> @persons_details[:suburb],
         "LBD_VCID_verifyenrolment_ctl00_contentplaceholderbody_captchacode"=> captcha_id,
         "ctl00$ContentPlaceHolderBody$CaptchaCodeTextBox"=> captcha_text,
         "ctl00$ContentPlaceHolderBody$buttonVerify"=>"Verify Enrolment"
      },
      :headers => {
        "Cookie" => aec_cookies
      }
    }


    EnrolmentCheck.post("/VerifyEnrolment.aspx", options).parsed_response
  end
end
