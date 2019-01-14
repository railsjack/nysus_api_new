class EstablishmentCategory < ActiveRecord::Base
	has_and_belongs_to_many :establishments

	searchable do
	    text :title, :as => :title_textp
	end

	def to_label
    "#{title}"
  end
end
