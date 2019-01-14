class Event < ActiveRecord::Base
  belongs_to :establishment
  default_scope { where( "start_time>='#{(DateTime.now-24.hours).to_s}'" ) }
  
  validates_presence_of :start_time

  delegate :latitude, :longitude, to: :establishment

  searchable do
    latlon(:location) { Sunspot::Util::Coordinates.new(establishment.latitude, establishment.longitude) }
  end

  def distance_away_from(cd)
    location = [cd.first.to_f, cd.last.to_f]
    distance = Geocoder::Calculations.distance_between(coordinates, location)
    distance.round(1)
  end

  def coordinates
    [latitude, longitude]
  end

  def typus_name
     title
   end
end
