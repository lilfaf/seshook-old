class Address < ActiveRecord::Base
  validates :street,       presence: true, uniqueness: { scope: :city }
  validates :city,         presence: true
  validates :country_code, presence: true

  belongs_to :addressable, polymorphic: true

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
