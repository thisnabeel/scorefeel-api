class FigureSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :birth_date, :death_date, :position, :created_at, :updated_at, :age, :alive?

  belongs_to :sport
  has_many :relationships
  has_many :events
  has_many :stories
  has_many :pictures
  has_many :tags

  def age
    object.age
  end

  def alive?
    object.alive?
  end
end 