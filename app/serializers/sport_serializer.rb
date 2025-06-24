class SportSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :created_at, :updated_at
end 