class Album < ActiveRecord::Base
  include TemporalScopes
  include Photoable
  include RansackSearchable

  validates :name, presence: true, uniqueness: { scope: :albumable_id }

  belongs_to :user
  belongs_to :albumable, polymorphic: true

  has_many :photos, as: :photoable, dependent: :destroy
end
