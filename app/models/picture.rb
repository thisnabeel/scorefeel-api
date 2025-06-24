class Picture < ApplicationRecord
  belongs_to :picturable, polymorphic: true

  validates :caption, presence: true
  validates :picturable, presence: true

  scope :covers, -> { where(cover: true) }
  scope :ordered, -> { order(created_at: :desc) }
end
