class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :date, presence: true
  validates :eventable, presence: true

  scope :ordered, -> { order(date: :desc) }
end 