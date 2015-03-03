module TemporalScopes
  extend ActiveSupport::Concern

  included do
    scope :created_between, -> (after, before) {
      where('created_at >= ? AND created_at <= ?', after, before)
    }

    scope :created_by_day, -> (after) {
      created_between(after, Time.now).group_by_day(:created_at)
    }

    scope :created_by_month, -> (after) {
      created_between(after, Time.now).group_by_month(:created_at)
    }

    scope :recent, -> (num) { order('created_at DESC').limit(num) }
  end
end
