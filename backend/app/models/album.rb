class Album < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :albumable_id }

  has_many   :photo, as: :photoable, dependent: :destroy
  belongs_to :albumable, polymorphic: true
end
