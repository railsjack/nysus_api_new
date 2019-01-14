object @establishment

attributes :id,
    :name,
    :address_1,
    :address_2,
    :city,
    :state,
    :zipcode,
    :phone,
    :website,
    :facebook_url,
    :twitter_url,
    :youtube_url,
    :logo_url,
    :description,
    :latitude,
    :longitude,
    :featured,
    :featured_text,
    :distance

child :specials do
    attributes :id, :title, :description, :start_time, :end_time, :created_at, :updated_at
end

child :events do
    attributes :id, :title, :description, :start_time, :end_time, :created_at, :updated_at
end

child :establishment_categories do
    attributes :id, :title
end

child :user do
    attributes :id
end
