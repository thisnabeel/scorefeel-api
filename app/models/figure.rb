class Figure < ApplicationRecord
  belongs_to :sport, optional: true
  has_many :relationship_figures, dependent: :destroy
  has_many :relationships, through: :relationship_figures
  has_many :events, as: :eventable, dependent: :destroy
  has_many :stories, as: :storyable, dependent: :destroy
  has_many :pictures, as: :picturable, dependent: :destroy
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :summary, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :death_date, comparison: { greater_than: :birth_date }, if: -> { birth_date.present? && death_date.present? }

  scope :ordered, -> { order(:position, :title) }

  def age
    return nil unless birth_date.present?
    
    end_date = death_date.present? ? death_date : Date.current
    end_date.year - birth_date.year - (end_date.to_date < birth_date.to_date + end_date.year.years ? 1 : 0)
  end

  def alive?
    death_date.blank?
  end
end 