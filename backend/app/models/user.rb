class User < ActiveRecord::Base
  include TemporalScopes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:member, :admin, :superadmin]

  mount_uploader :avatar, AvatarUploader

  validates :role, presence: true

  has_many :spots
  has_many :photos
  has_many :albums

  s3_relay :avatar_upload

  after_commit :import_avatar_upload, on: :create

  def import_upload(upload_id)
    ProcessAvatarJob.perform_later(self, S3Relay::Upload.find(upload_id))
  end

  private

  def import_avatar_upload
    if avatar_upload.present?
      ProcessAvatarJob.perform_later(self, avatar_upload)
    end
  end
end
