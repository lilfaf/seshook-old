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

  def self.from_facebook_auth(hash)
    where(email: hash['email']).first_or_initialize.tap do |u|
      u.username ||= hash['name'].gsub(' ', '')
      u.first_name = hash['first_name']
      u.last_name = hash['last_name']
      u.gender = hash['gender']
      u.locale = hash['locale'].split('_').last
      u.birthday = Date.strptime(hash['birthday'], '%m/%d/%Y')
      u.fb_access_token = hash['access_token']
      u.fb_access_token_expires_at = Time.now + hash['expires'].to_i.seconds
      u.facebook_id = hash['id']
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
    if fb_access_token.present? && !avatar?
      FacebookAvatarJob.perform_later(self)
    end
  end
end
