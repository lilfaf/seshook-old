module Photoable
  extend ActiveSupport::Concern

  included do
    has_many :photos, as: :photoable, dependent: :destroy

    s3_relay :photo_uploads, has_many: true

    after_commit :import_photo_uploads, on: :create
  end

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
end