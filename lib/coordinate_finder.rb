require 'awesome_print'

class CoordinateFinder
  def self.execute(limit = 10)
    establishments = Establishment.all.order('updated_at DESC').limit(limit)
    establishments.each do |e|
      unless has_coordinates?(e)
        ap address_string = "#{e.address_1} #{e.city}, #{e.state} #{e.zipcode.to_s}"
        ap coordinates = Geocoder.coordinates(address_string)
        if coordinates
          e.update_attributes(latitude: coordinates.first, longitude: coordinates.last)
        else
          ap "------ Establishment named #{e.name} did not find coordinates."
        end
        sleep 0.5
      else
        ap "Establishment named #{e.name} has coordinates"
      end
    end
  end

  def self.has_coordinates?(establishment)
    establishment.latitude && establishment.latitude
  end
end
