class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :tagable, polymorphic: true

  validates :tag_id, presence: true
  validates :tagable, presence: true
  validates :tag_id, uniqueness: { scope: [:tagable_id, :tagable_type] }
end 