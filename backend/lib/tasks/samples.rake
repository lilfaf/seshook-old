require 'samples/loader'

namespace :samples do
  desc 'Remove files without exif gps location'
  task :clean do
    files = Dir.glob(Rails.root.join('images').join('*')).reject { |f| File.directory?(f) }
    files.each { |f| File.delete(f) unless EXIFR::JPEG.new(f).gps }
  end

  desc 'Seeds data from images'
  task :seed => :environment do
    Rake::Task['samples:clean'].invoke
    Samples::Loader.perform
  end
end
