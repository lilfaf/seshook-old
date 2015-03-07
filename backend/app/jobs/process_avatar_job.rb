class ProcessAvatarJob < ActiveJob::Base
  def perform(user, upload)
    user.remote_avatar_url = upload.private_url
    user.save!
    upload.mark_imported!
  end
end
