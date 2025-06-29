class SportSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :public, :created_at, :updated_at
  
  has_many :figures
  has_many :sport_rules
  has_many :tags
  has_many :events
  has_many :stories
  has_many :pages
end 