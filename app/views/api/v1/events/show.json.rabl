object @event

attributes :id,
    :title,
    :description,
    :price,
    :start_time,
    :end_time,
    :created_at,
    :updated_at

child :establishment do
    attributes :id, :name
end

node(:distance_away) { |special| special.distance_away_from(@current_location) }
