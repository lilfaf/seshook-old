module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search_for(*args, &block)
      __elasticsearch__.search(*args, &block)
    end
  end
end