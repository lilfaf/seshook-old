class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :avatar, :avatar_thumb, :created_at, :updated_at

  def avatar
    object.avatar.url
  end

  def avatar_thumb
    object.avatar.thumb.url
  end
end
