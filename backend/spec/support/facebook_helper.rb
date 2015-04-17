module FacebookHelper
  def test_users
    @test_users ||= Koala::Facebook::TestUsers.new(
      app_id: ENV['FACEBOOK_APP_ID'],
      secret: ENV['FACEBOOK_APP_SECRET']
    )
  end

  def fb_user
    if test_users.list.empty?
      test_users.create(true,
        'public_profile,email,user_birthday', name: 'John Doe'
      )
    end
    test_users.list.first
  end

  def fb_user_email
    Koala::Facebook::API.new(fb_user['access_token']).get_object('me')['email']
  end
end