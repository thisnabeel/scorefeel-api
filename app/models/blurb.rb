class Blurb < ApplicationRecord
  belongs_to :blurbable, polymorphic: true

  validates :title, presence: true
  validates :description, presence: true
  validates :blurbable, presence: true

  scope :starred, -> { where(starred: true) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :for_blurbable, ->(blurbable_type, blurbable_id) { 
    where(blurbable_type: blurbable_type, blurbable_id: blurbable_id) 
  }
end 