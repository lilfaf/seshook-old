module RansackSearchable
  extend ActiveSupport::Concern

  included do
    # Allow searching by country name
    country_formatter = proc do |v|
      countries = Country.all do |country, data|
        [data['translations']['en'], country]
      end
      country = countries.detect do |name, _|
        name.downcase.eql?(v.downcase) if name
      end
      country ? country.last : v
    end

    ransacker :country, formatter: country_formatter do |parent|
      parent.table[:country_code]
    end
  end

  module ClassMethods
    # Uses ransack to search and sort.
    def search_with_sort(search = {})
      results = self.search(search)
      results.sorts = 'created_at desc' if results.sorts.empty?
      results
    end
  end
end
