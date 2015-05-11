class Spot < ActiveRecord::Base
  include TemporalScopes
  include Photoable
  include RansackSearchable

  ## Configuration ------------------------------------------------------------

  searchkick

  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :lonlat, GEO_FACTORY

  attr_accessor :latitude, :longitude, :new_photo_uploads_uuids

  enum status: [:pending, :approved, :rejected]

  ## Validations --------------------------------------------------------------

  validates :latitude,  presence: true, numericality: {
    greater_than_or_equal_to: -90,  less_than_or_equal_to: 90
  }

  validates :longitude, presence: true, numericality: {
    greater_than_or_equal_to: -180, less_than_or_equal_to: 180
  }

  validate  :lonlat_uniqueness

  validates_associated :address

  ## Associations -------------------------------------------------------------

  belongs_to :user
  has_one    :address, as: :addressable, dependent: :destroy
  has_many   :albums,  as: :albumable,   dependent: :destroy

  accepts_nested_attributes_for :address

  ## Scopes -------------------------------------------------------------------

  scope :search_import, -> { includes(:address) }

  ## Callbacks ----------------------------------------------------------------

  after_initialize  :finalize

  before_validation :update_lonlat

  ## Instance methods ---------------------------------------------------------

  def finalize
    if lonlat.present?
      self.latitude ||= lonlat.y
      self.longitude ||= lonlat.x
    end
  end

  def update_lonlat
    lat = latitude || lonlat.try(:y)
    lon = longitude || lonlat.try(:x)
    self.lonlat = GEO_FACTORY.point(lon, lat)
  end

  def lonlat_uniqueness
    record = self.class.where(lonlat: lonlat)
    record = record.where.not(id: id) if persisted?
    errors.add(:lonlat, :taken) if record.exists?
  end

  def search_data
    as_json(only: [:id, :name]).merge(
      address.as_json(except: [:id, :created_at, :updated_at]).merge(
        { country: address.country_name }
      )
    )
  end

  ## Class methods ------------------------------------------------------------

  def self.close_to(latitude, longitude, distance_in_meters = 2000)
    where(%Q{
      ST_DWithin(
        spots.lonlat,
        ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})'),
        #{distance_in_meters}
        )
    })
  end

  def self.closest(latitude, longitude)
    close_to(latitude, longitude).order(%Q{
      ST_Distance(
        spots.lonlat,
        ST_GeomFromEWKT('SRID=4326;POINT(#{longitude} #{latitude})')
        )
    }).first
  end
end
