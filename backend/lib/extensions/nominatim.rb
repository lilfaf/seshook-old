module Geocoder::Result
  class Nominatim < Base
    def street
      %w[road pedestrian path footway cycleway highway].each do |key|
        return @data['address'][key] if @data['address'].key?(key)
      end
    end
  end
end
