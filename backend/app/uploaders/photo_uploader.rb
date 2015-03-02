class PhotoUploader < BaseImageUploader
  process :fix_exif_rotation
  process :strip

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end

  def strip
    manipulate! do |img|
      img.strip
      img = yield(img) if block_given?
      img
    end
  end

  version :large do
    process resize_to_fit: [1000, 1000]
  end

  version :small do
    process resize_to_fill: [100, 100]
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end
end
