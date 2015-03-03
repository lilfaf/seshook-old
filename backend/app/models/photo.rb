class Photo < ActiveRecord::Base
  include TemporalScopes

  mount_uploader :file, PhotoUploader

  validates :file,         presence: true
  validates :content_type, presence: true
  validates :size,         presence: true

  belongs_to :photoable, polymorphic: true

  before_validation :update_file_attributes

  private

  def update_file_attributes
    return unless file.present? && file_changed?
    self.content_type = file.file.content_type
    self.size = file.file.size
  end
end
