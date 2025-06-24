class Relationship < ApplicationRecord
  has_many :relationship_figures, dependent: :destroy
  has_many :figures, through: :relationship_figures
  has_many :events, as: :eventable, dependent: :destroy
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
end 