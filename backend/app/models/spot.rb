class Spot < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :lonlat, GEO_FACTORY

  attr_accessor :latitude, :longitude, :new_uploads_uuids

  enum status: [:pending, :approved, :rejected]

  validates :latitude,  presence: true, numericality: { greater_than_or_equal_to: -90,  less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  validate  :lonlat_uniqueness

  belongs_to :user
  has_one    :address, as: :addressable, dependent: :destroy
  has_many   :photos,  as: :photoable,   dependent: :destroy
  has_many   :albums,  as: :albumable,   dependent: :destroy

  s3_relay :photo_uploads, has_many: true

  accepts_nested_attributes_for :address

  after_initialize  :finalize
  before_validation :update_lonlat
  after_commit      :import_photo_uploads, on: :create

  # Called when an associated S3Relay::Upload object is created
  def import_upload(upload_id)
    enqueue_photo_processing(S3Relay::Upload.find(upload_id))
  end

  private

  def import_photo_uploads
    photo_uploads.pending.each do |upload|
      enqueue_photo_processing(upload)
    end
  end

  def enqueue_photo_processing(upload)
    ProcessPhotoJob.perform_later(self, upload)
  end

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
end
