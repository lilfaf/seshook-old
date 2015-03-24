class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street, :zip, :city, :state, :country

  def country
    object.country_name
  end
end
