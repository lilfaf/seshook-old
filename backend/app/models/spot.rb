class Spot < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :lonlat, GEO_FACTORY

  attr_accessor :latitude, :longitude

  enum status: [:pending, :approved, :rejected]

  validates :latitude,  presence: true, numericality: { greater_than_or_equal_to: -90,  less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  validate  :lonlat_uniqueness

  belongs_to :user
  has_one    :address, as: :addressable, dependent: :destroy
  has_many   :photos,  as: :photoable,   dependent: :destroy
  has_many   :albums,  as: :albumable,   dependent: :destroy

  accepts_nested_attributes_for :address

  after_initialize  :finalize
  before_validation :set_lonlat

  private

  def finalize
    if lonlat.present?
      self.latitude  ||= lonlat.y
      self.longitude ||= lonlat.x
    end
  end

  def set_lonlat
    lat = latitude  || lonlat.try(:y)
    lon = longitude || lonlat.try(:x)
    self.lonlat = GEO_FACTORY.point(lon, lat)
  end

  def lonlat_uniqueness
    record = self.class.where(lonlat: lonlat)
    record = record.where.not(id: id) if persisted?
    errors.add(:lonlat, :taken) if record.exists?
  end
end

