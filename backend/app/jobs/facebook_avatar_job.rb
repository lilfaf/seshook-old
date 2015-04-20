class FacebookAvatarJob < ActiveJob::Base
  def perform(user)
    avatar_url = user.facebook.get_picture(user.facebook_id, type: :large)
    user.remote_avatar_url = avatar_url
    user.save!
  end
end
