class User < ActiveRecord::Base
  include TemporalScopes
  include RansackSearchable

  ## Configuration -----------------------------------------------------------

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  s3_relay :avatar_upload

  mount_uploader :avatar, AvatarUploader

  enum role:   [:member, :admin, :superadmin]
  enum gender: [:male, :female]

  ## Validations --------------------------------------------------------------

  validates :role, :username, presence: true
  validates :facebook_id, uniqueness: true, allow_blank: true

  ## Associations -------------------------------------------------------------

  has_many :spots
  has_many :photos
  has_many :albums

  ## Callbacks ----------------------------------------------------------------

  after_commit :import_avatar_upload, on: :create

  ## Instance methods ---------------------------------------------------------

  def import_upload(upload_id)
    ProcessAvatarJob.perform_later(self, S3Relay::Upload.find(upload_id))
  end

  def full_name
    "#{first_name} #{last_name}".squish
  end

  def password_required?
     super && facebook_id.blank?  # TODO test facebook token present
   end

  private

  def import_avatar_upload
    if avatar_upload.present?
      ProcessAvatarJob.perform_later(self, avatar_upload)
    end
  end
end
