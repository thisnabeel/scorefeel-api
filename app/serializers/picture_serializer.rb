class PictureSerializer < ActiveModel::Serializer
  attributes :id, :caption, :image_url, :storage_key, :cover, :created_at, :updated_at
end 