class Facebook
  attr_reader :oauth_token, :token_expires_at

  def initialize(*options)
    @oauth_token = options['access_token']
    @oauth_expires_at = Time.now + options['expires'].to_i.seconds
  end

  def facebook
    Koala::Facebook::API.new(oauth_token)
  end

  #def authenticate()

  def find_or_build_user
    hash = facebook.get_object('me')
    User.where(email: hash['email']).first_or_initialize.tap do |u|
      u.oauth_token      = oauth_token
      u.oauth_expires_at = oauth_expires_at
      u.facebook_id      = hash['id']
      u.username         = hash['name'].gsub(' ', '')
      u.first_name       = hash['first_name']
      u.last_name        = hash['last_name']
      u.gender           = hash['gender']
      u.verified         = hash['verified']
      u.locale           = hash['locale'].split('_').last
      u.birthday         = Date.strptime(hash['birthday'], '%m/%d/%Y')
    end
  end
end