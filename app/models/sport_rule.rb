class SportRule < ApplicationRecord
  belongs_to :sport
  has_many :events, as: :eventable, dependent: :destroy
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :summary, presence: true
  validates :body, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  # Cache invalidation callbacks
  after_commit :clear_sports_cache, on: [:create, :update, :destroy]

  private

  def clear_sports_cache
    Rails.cache.delete("sports_index")
  end
end 