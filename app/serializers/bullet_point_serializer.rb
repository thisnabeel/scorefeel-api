class BulletPointSerializer < ActiveModel::Serializer
  attributes :id, :body, :bullet_pointable_type, :bullet_pointable_id, :position, :created_at, :updated_at

  belongs_to :bullet_pointable
end 