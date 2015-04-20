class User < ActiveRecord::Base
  include TemporalScopes
  include RansackSearchable

  ## Configuration -----------------------------------------------------------

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  s3_relay :avatar_upload

  mount_uploader :avatar, AvatarUploader

  enum role: [:member, :admin, :superadmin]
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
  after_create :process_facebook_avatar

  ## Instance methods ---------------------------------------------------------

  def import_upload(upload_id)
    ProcessAvatarJob.perform_later(self, S3Relay::Upload.find(upload_id))
  end

  def full_name
    "#{first_name} #{last_name}".squish
  end

  def password_required?
    super && (facebook_id.blank? && fb_access_token.blank?)
  end

  def facebook
    Koala::Facebook::API.new(fb_access_token)
  end

  ## Class methods ------------------------------------------------------------

  def self.from_facebook_auth(resp)
    where(email: resp.email).first_or_initialize.tap do |u|
      u.assign_attributes(resp.body)

      u.username = resp.info[:name].gsub(' ', '') if u.new_record?
      u.save
    end
  end

  ## Private ------------------------------------------------------------------

  private

  def import_avatar_upload
    if avatar_upload.present?
      ProcessAvatarJob.perform_later(self, avatar_upload)
    end
  end

  def process_facebook_avatar
    unless avatar?
      self.remote_avatar_url = facebook.get_picture(facebook_id, type: :large)
      save
    end
    # background process
    #if fb_access_token.present? && !avatar?
    #  FacebookAvatarJob.perform_later(self)
    #end
  end
end
