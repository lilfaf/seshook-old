class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email,
    :avatar, :avatar_medium, :avatar_thumb,
    :created_at, :updated_at

  def avatar
    object.avatar.url
  end

  def avatar_medium
    object.avatar.medium.url
  end

  def avatar_thumb
    object.avatar.thumb.url
  end
end
