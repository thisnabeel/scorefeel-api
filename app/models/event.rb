class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :start_date, presence: true
  validates :eventable, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }, if: -> { start_date.present? && end_date.present? }

  scope :ordered, -> { order(start_date: :desc) }

  before_save :set_end_date_if_blank

  def duration_days
    return 1 if end_date.blank? || start_date.blank?
    (end_date - start_date).to_i + 1
  end

  def is_multi_day?
    end_date.present? && start_date.present? && end_date > start_date
  end

  private

  def set_end_date_if_blank
    self.end_date = start_date if end_date.blank? && start_date.present?
  end
end 