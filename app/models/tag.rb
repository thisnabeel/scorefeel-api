class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :figures, through: :taggings, source: :tagable, source_type: 'Figure'
  has_many :sports, through: :taggings, source: :tagable, source_type: 'Sport'
  has_many :sport_rules, through: :taggings, source: :tagable, source_type: 'SportRule'
  has_many :relationships, through: :taggings, source: :tagable, source_type: 'Relationship'
  has_many :events, through: :taggings, source: :tagable, source_type: 'Event'
  has_many :stories, through: :taggings, source: :tagable, source_type: 'Story'

  validates :title, presence: true, uniqueness: true
  validates :summary, presence: true

  scope :ordered, -> { order(:title) }
end 