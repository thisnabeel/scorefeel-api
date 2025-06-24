class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  has_many :pictures
end 