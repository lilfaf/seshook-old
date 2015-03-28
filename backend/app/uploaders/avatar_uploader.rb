class AvatarUploader < BaseImageUploader

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "avatar.png"].compact.join('_'))
  end

  version :medium do
    process resize_to_fill: [200, 200]
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end
end
