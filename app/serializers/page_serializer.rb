class PageSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :position, :level, :pageable_type, :pageable_id, :full_path, :created_at, :updated_at

  belongs_to :pageable
  has_many :bullet_points
end 