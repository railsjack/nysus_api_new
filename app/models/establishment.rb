class Establishment < ActiveRecord::Base
  # attr_accessible :name,
  #     :address_1,
  #     :address_2,
  #     :city,
  #     :state,
  #     :zipcode,
  #     :phone,
  #     :website,
  #     :facebook_url,
  #     :twitter_url,
  #     :youtube_url,
  #     :description

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_many :events
  has_many :specials
  has_and_belongs_to_many :establishment_categories

  belongs_to :user
  
  geocoded_by :address
  after_validation :geocode

  searchable do
    text :name, :as => :name_textp
    string :city
    string :state
    integer :zipcode
    double :latitude
    double :longitude 
    time :updated_at
    boolean :featured
    integer :category_ids, multiple: true do 
      establishment_categories.map(&:id)
    end 
    string :name_sort do 
      name
    end
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

  def address
    address_1.to_s + " " + address_2.to_s + " " + city.to_s + ", " + state.to_s + " " + zipcode.to_s
  end

  def coordinates
    [latitude, longitude]
  end

  def distance_away_from(cd)
    location = [cd.first.to_f, cd.last.to_f]
    distance = Geocoder::Calculations.distance_between(coordinates, location)
    distance.round(1)
  end

  def self.cities
    Establishment.order("city ASC").pluck(:city).uniq
  end

  def self.states
    Establishment.order("state ASC").pluck(:state).uniq
  end

  def self.zipcodes
    Establishment.order("zipcode ASC").pluck(:zipcode).uniq
  end

end
