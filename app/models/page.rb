class Page < ApplicationRecord
  belongs_to :pageable, polymorphic: true, optional: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :bullet_points, -> { order(:position) }, as: :bullet_pointable, dependent: :destroy

  scope :ordered, -> { order(:position, :level, :created_at) }
  scope :for_pageable, ->(pageable_type, pageable_id) { 
    where(pageable_type: pageable_type, pageable_id: pageable_id) 
  }
  scope :by_level, ->(level) { where(level: level) }

  before_validation :generate_slug, if: :title_changed?

  def to_param
    slug
  end

  def full_path
    if pageable.present?
      "#{pageable.class.name.downcase}/#{pageable.id}/pages/#{slug}"
    else
      "pages/#{slug}"
    end
  end

  private

  def generate_slug
    return if title.blank?
    
    base_slug = title.parameterize
    counter = 0
    new_slug = base_slug
    
    while Page.where(slug: new_slug).where.not(id: id).exists?
      counter += 1
      new_slug = "#{base_slug}-#{counter}"
    end
    
    self.slug = new_slug
  end
end 