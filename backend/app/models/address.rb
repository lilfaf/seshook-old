class Address < ActiveRecord::Base
  include RansackSearchable

  ## Validations --------------------------------------------------------------

  validates :street,       presence: true, uniqueness: { scope: :city }
  validates :city,         presence: true
  validates :country_code, presence: true

  ## Associations -------------------------------------------------------------

  belongs_to :addressable, polymorphic: true, touch: true

  ## Instance methods ---------------------------------------------------------

  def country_name
    country = Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end
end
