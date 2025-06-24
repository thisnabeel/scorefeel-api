class RelationshipFigure < ApplicationRecord
  belongs_to :figure
  belongs_to :relationship

  validates :figure_id, presence: true
  validates :relationship_id, presence: true
  validates :figure_id, uniqueness: { scope: :relationship_id }
end 