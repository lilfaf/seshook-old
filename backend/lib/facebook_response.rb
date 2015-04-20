class FacebookResponse
  attr_accessor :info

  def initialize(profile, access_token)
    @info = profile.merge(access_token).symbolize_keys!
  end

  def body
    {
      facebook_id: info[:id],
      first_name: info[:first_name],
      last_name: info[:last_name],
      gender: info[:gender],
      locale: locale,
      birthday: birthday,
      fb_access_token: info[:access_token],
      fb_access_token_expires_at: token_expires_at,
    }
  end

  def email
    info[:email]
  end

  def birthday
    Date.strptime(info[:birthday], '%m/%d/%Y')
  end

  def locale
    info[:locale].split('_').last
  end

  def token_expires_at
    Time.now + info[:expires].to_i.seconds
  end
end