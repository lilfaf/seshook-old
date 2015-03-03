class Album < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :albumable_id }

  has_many   :photos, as: :photoable, dependent: :destroy
  belongs_to :albumable, polymorphic: true
end
