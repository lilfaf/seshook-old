class SpotSerializer < ActiveModel::Serializer
  attributes :id, :latlon, :created_at, :updated_at

  def latlon
    [object.latitude, object.longitude]
  end
end
