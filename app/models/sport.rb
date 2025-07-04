class Sport < ApplicationRecord
  belongs_to :sport, optional: true
  has_many :figures, dependent: :destroy
  has_many :sport_rules, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  # Stories through related entities
  has_many :figure_stories, through: :figures, source: :stories
  has_many :sport_rule_stories, through: :sport_rules, source: :stories
  has_many :event_stories, through: :events, source: :stories
  has_many :pages, as: :pageable, dependent: :destroy

  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  scope :ordered, -> { order(:position, :title) }

  # Cache invalidation callbacks
  after_commit :clear_sports_cache, on: [:create, :update, :destroy]
  after_commit :clear_sports_cache, on: [:create, :update, :destroy], if: :saved_change_to_title?

  # Get all stories related to this sport (direct + through related entities)
  def all_stories
    Story.where(id: [
      stories.pluck(:id),
      figure_stories.pluck(:id),
      sport_rule_stories.pluck(:id),
      event_stories.pluck(:id)
    ].flatten.uniq).includes(:storyable, :tags).ordered
  end

  private

  def clear_sports_cache
    Rails.cache.delete("sports_index")
  end
end 