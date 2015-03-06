require 'rails_helper'
require "#{Rails.root}/lib/extensions/nominatim"

describe Geocoder::Result::Nominatim do
  describe '#street' do
    subject {
      described_class.new({
        'address' => {
          'path' => 'path-test',
          'footway' => 'footway-test',
          'cycleway' => 'cycleway-test'
        }
        })
    }

    it 'returns path' do
      expect(subject.street).to eq('path-test')
    end

    context 'path not present' do
      before { subject.data['address'].delete('path') }

      it 'returns footway' do
        expect(subject.street).to eq('footway-test')
      end
    end

    context 'path and footway not present' do
      before do
        subject.data['address'].delete('path')
        subject.data['address'].delete('footway')
      end

      it 'returns cycleway' do
        expect(subject.street).to eq('cycleway-test')
      end
    end
  end
end
