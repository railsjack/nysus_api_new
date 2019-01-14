class Special < ActiveRecord::Base

  default_scope { where( "start_time>='#{(DateTime.now-24.hours).to_s}'" ) }

  STATUS = %w(One-Time Daily Weekly Monthly)

  belongs_to :establishment

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

  def all_day_event
    return ((end_time - start_time) / 3600).ceil == 24
  end

  def self.recurrings
    STATUS
  end

  def typus_name
    title
  end

  def self.updateDates
    Special.where(["end_time < ?", DateTime.now]).all.each do |s|
      # see if the event is in the past
      if s.recurring.nil? || s.recurring == "One-Time"
        s.destroy
      else
        if s.recurring == "Daily"
          s.start_time = s.start_time + 1.day
          s.end_time = s.end_time + 1.day
        elsif s.recurring == "Weekly"
          s.start_time = s.start_time +  1.week
          s.end_time = s.end_time + 1.week
        elsif s.recurring == "Monthly"
          s.start_time = s.start_time +  1.month
          s.end_time = s.end_time + 1.month
        end
        s.save
      end
  end
  end
end
