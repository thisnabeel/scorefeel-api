class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :start_date, :end_date, :duration_days, :is_multi_day, :created_at, :updated_at

  belongs_to :eventable
end 