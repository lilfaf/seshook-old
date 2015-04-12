class Photo < ActiveRecord::Base
  include TemporalScopes

  ## Configuration ------------------------------------------------------------

  mount_uploader :file, PhotoUploader

  ## Validations --------------------------------------------------------------

  validates :file,         presence: true
  validates :content_type, presence: true
  validates :size,         presence: true

  ## Associations -------------------------------------------------------------

  belongs_to :user
  belongs_to :photoable, polymorphic: true

  ## Callbacks ----------------------------------------------------------------

  before_validation :update_file_attributes

  ## Instance methods ---------------------------------------------------------

  private

  def update_file_attributes
    return unless file.present? && file_changed?
    self.content_type = file.file.content_type
    self.size = file.file.size
  end
end
