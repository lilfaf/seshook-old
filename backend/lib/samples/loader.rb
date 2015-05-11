require 'extensions/nominatim'

module Samples
  class Loader
    def self.perform
      new.import
    end

    def initialize
      Geocoder.configure(
        lookup: :nominatim,
        units: :km,
        cache: cache
      )
    end

    def import
      imgs = Dir[load_path].reject { |f| File.directory?(f) }
      imgs.each do |img|
        begin
          gps = EXIFR::JPEG.new(img).gps
        rescue EXIFR::MalformedJPEG
          next
        end

        lat = gps.latitude
        lon = gps.longitude
        # reverse geocode gps location
        info = Geocoder.search(
          "#{lat},#{lon}",
          params: {"accept-language" => "us"}
        ).first
        if spot = find_matching_spot(info, lat, lon)
          # add image to matching spot
          spot.photos << Photo.create!(file: File.open(img))
        elsif info
          # create a new entry
          spot = Spot.new(latitude: lat, longitude: lon)
          spot.address = build_address(info)
          spot.photos << Photo.new(file: File.open(img))
          spot.save!
        end

        unless Rails.env.test?
          puts "#{img} processed successfully"
        end
      end
    end

    private

    def find_matching_spot(info, lat, lon)
      # return spot from address
      address = Address.find_by_street(street(info))
      return address.addressable if address
      # or from closest location
      if spot = Spot.closest(lat, lon)
        distance = Geocoder::Calculations.distance_between(
          [spot.latitude, spot.longitude],
          [lat, lon]
        )
        distance * 1000 < offset ? spot : nil
      else
        nil
      end
    end

    def build_address(info)
      Address.new(
        street:       street(info),
        zip:          zip(info),
        city:         info.city,
        state:        info.state,
        country_code: info.country_code.upcase
      )
    end

    def load_path
      File.join((ENV['IMAGES_PATH'] || Rails.root.join('photos')), '*')
    end

    def offset
      ENV['OFFSET'] || 150
    end

    def cache
      ENV['USE_REDIS_CACHE'] == 'true' ? Redis.new : Hash.new
    end

    def street(info)
      [info.house_number, info.street].join(' ')
    end

    def zip(info)
      info.postal_code.split(';').first rescue "0"
    end
  end
end