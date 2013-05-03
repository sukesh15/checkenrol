require "base64"

class DataUrlParser < HTTParty::Parser
  SupportedFormats.merge!('image/jpeg' => :data_url)

  def data_url
    "data:image/jpeg;base64," + Base64.strict_encode64(body)
  end
end

class CaptchaImage
  include HTTParty
  parser DataUrlParser
  
  attr_reader :captcha_id
  
  def initialize(options={})
    r = Random.new.rand
    @captcha_id = Digest::MD5.hexdigest("alex" + r.to_s)
    @response = CaptchaImage.get("https://oevf.aec.gov.au/BotDetectCaptcha.ashx?get=image&c=verifyenrolment_ctl00_contentplaceholderbody_captchacode&t=#{@captcha_id}", options)
  end
  
  def data_uri
    @response.parsed_response
  end
  
  def cookies
    @response.headers['set-cookie']
  end
  
end