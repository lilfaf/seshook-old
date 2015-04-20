class Album < ActiveRecord::Base
  include TemporalScopes
  include Photoable
  include RansackSearchable

  ## Validations --------------------------------------------------------------

  validates :name, presence: true, uniqueness: { scope: :albumable_id }

  ## Associations -------------------------------------------------------------

  belongs_to :user
  belongs_to :albumable, polymorphic: true

  has_many :photos, as: :photoable, dependent: :destroy
end
