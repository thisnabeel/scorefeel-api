class Story < ApplicationRecord
  belongs_to :storyable, polymorphic: true
  has_many :pictures, as: :picturable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :body, presence: true
  validates :storyable, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end 