#class Facebook
#  attr_reader :oauth_token, :token_expires_at
#
#  def initialize(*options)
#    @oauth_token = options['access_token']
#    @oauth_expires_at = Time.now + options['expires'].to_i.seconds
#  end
#
#  def facebook
#    Koala::Facebook::API.new(oauth_token)
#  end
#
#  #def authenticate()
#
#  def find_or_build_user
#    hash = facebook.get_object('me')
#    User.where(email: hash['email']).first_or_initialize.tap do |u|
#      u.oauth_token      = oauth_token
#      u.oauth_expires_at = oauth_expires_at
#      u.facebook_id      = hash['id']
#      u.username         = hash['name'].gsub(' ', '')
#      u.first_name       = hash['first_name']
#      u.last_name        = hash['last_name']
#      u.gender           = hash['gender']
#      u.verified         = hash['verified']
#      u.locale           = hash['locale'].split('_').last
#      u.birthday         = Date.strptime(hash['birthday'], '%m/%d/%Y')
#    end
#  end
#end

class FacebookResponse
  attr_accessor :info

  def initialize(profile, access_token)
    @info = profile.merge(access_token).symbolize_keys!

    #@info = info.symbilize_keys!
    #@info = info
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