class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :bullet_points

  has_many :pictures

  def bullet_points
    object.bullet_points.order(:position).map do |bullet_point|
      {
        id: bullet_point.id,
        body: bullet_point.body,
        created_at: bullet_point.created_at,
        updated_at: bullet_point.updated_at
      }
    end
  end
end 