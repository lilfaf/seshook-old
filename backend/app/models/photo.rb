class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  validates :file,         presence: true
  validates :content_type, presence: true
  validates :size,         presence: true

  belongs_to :photoable, polymorphic: true
end
