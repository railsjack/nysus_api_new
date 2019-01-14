class Admin::SpecialsController < Admin::ResourcesController

	def new
		@item = Special.new
		if !params["_popup"].nil? && params["_popup"]
			referrer = request.referer.split("/")
			@item.establishment_id = referrer[referrer.count-1]
		end
	end
end
