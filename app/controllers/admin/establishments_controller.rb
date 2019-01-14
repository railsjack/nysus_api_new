class Admin::EstablishmentsController < Admin::ResourcesController
	def index
		if (params["city"].nil? || params["city"].blank?) && (params["state"].nil? || params["state"].blank?) && (params["zipcode"].nil? || params["zipcode"].blank?)
			@search = Establishment.search do
				fulltext params[:search] do
	              fields(:name)
	            end
			end
		else
			if !params["city"].blank? && !params["state"].blank? && !params["zipcode"].blank? #city, state, zip set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :city, params["city"]
		            with :state, params["state"]
		            with :zipcode, params["zipcode"]
				end
			elsif !params["city"].blank? && !params["state"].blank? && params["zipcode"].blank? #city, state set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :city, params["city"]
		            with :state, params["state"]
				end
			elsif !params["city"].blank? && params["state"].blank? && !params["zipcode"].blank? #city, zip set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :city, params["city"]
		            with :zipcode, params["zipcode"]
				end
			elsif params["city"].blank? && !params["state"].blank? && !params["zipcode"].blank? #state, zip set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :zipcode, params["zipcode"]
		            with :state, params["state"]
				end
			elsif !params["city"].blank? && params["state"].blank? && params["zipcode"].blank? #city set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :city, params["city"]
				end
			elsif params["city"].blank? && !params["state"].blank? && params["zipcode"].blank? #state set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :state, params["state"]
				end
			elsif params["city"].blank? && params["state"].blank? && !params["zipcode"].blank? #zip set
				@search = Establishment.search do
					fulltext params[:search] do
		              fields(:name)
		            end
		            with :zipcode, params["zipcode"]
				end
			end
		end
		@items = @search.results
	end
end
