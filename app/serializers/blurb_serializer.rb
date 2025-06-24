class BlurbSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :blurbable_type, :blurbable_id, :starred, :created_at, :updated_at

  belongs_to :blurbable
end 