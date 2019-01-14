module Api
  module V1
    class EstablishmentsController < ApplicationController
      before_filter :authenticate!, only: [:create, :edit]

      def index
        radius = params[:radius].nil? || params[:radius].blank? ? 2000 : params[:radius]
        current_location = [params[:latitude], params[:longitude]]
        filters = params["filters"].split(",") if !params["filters"].nil?
        if params["city"].nil?
          citystate = nil
        else
          citystate = params["city"].split("_") 
        end
        Rails.logger.info "------------ #{current_location}"
        if !params["search"].nil? && !filters.nil? && filters.count > 0 && citystate.count == 2
          filters.map{ |x| x.to_i }
          Rails.logger.info "filter and search set"
          @search = Establishment.search do
            fulltext params[:search] do
              fields(:name)
            end
            with :category_ids, filters
            without :latitude, nil
            with :city, citystate[0]
            with :state, citystate[1]
            with(:location).in_radius(current_location.first, current_location.last, radius)
            order_by :name_sort
            paginate :page => 1, :per_page => 50
          end
        elsif !params["search"].nil? && !filters.nil? && filters.count > 0 && (citystate.nil? || citystate.count != 2)
          filters.map{ |x| x.to_i }
          Rails.logger.info "filter and search set"
          @search = Establishment.search do
            fulltext params[:search] do
              fields(:name)
            end
            with :category_ids, filters
            without :latitude, nil
            without :city, nil
            without :state, nil
            with(:location).in_radius(current_location.first, current_location.last, radius)
            order_by :name_sort
            paginate :page => 1, :per_page => 50
          end
        elsif (filters.nil? || filters.count == 0) && !citystate.nil? && citystate.count == 2 #just fulltext
          Rails.logger.info "filter is empty"
          @search = Establishment.search do
            fulltext params[:search] do
              fields(:name)
            end
            #fulltext "{!func}geodist(location_ll, #{current_location.first}, #{current_location.last})"
            without :latitude, nil
            with :city, citystate[0]
            with :state, citystate[1]
            with(:location).in_radius(current_location.first, current_location.last, radius)
            order_by :score, :asc
            paginate :page => 1, :per_page => 50
          end
        elsif !params["search"].nil? && (filters.nil? || filters.count == 0) && citystate.nil? #no citystate
          Rails.logger.info "filter is empty"
          @search = Establishment.search do
            fulltext params[:search] do
              fields(:name)
            end
            without :latitude, nil
            without :city, nil
            without :state, nil
            with(:location).in_radius(current_location.first, current_location.last, radius)
            order_by_geodist(:location, current_location.first, current_location.last)
            paginate :page => 1, :per_page => 50
          end
        else
          @search = Establishment.search do
            without :latitude, nil
            without :city, nil
            without :state, nil
            with(:location).in_radius(current_location.first, current_location.last, radius)
            order_by_geodist(:location, current_location.first, current_location.last)
            paginate :page => 1, :per_page => 50
          end
        end
        @establishments = @search.results 
        @establishments = @establishments.each { |e| 
          e.distance=e.distance_from(current_location) 
        }.sort_by{|v| 
          v[:distance]}.each{|e|puts e.distance
        }
        @current_location = current_location
      end

      def show
        @establishment = Establishment.includes(:events, :specials, :establishment_categories).find(params[:id])
        @current_location = [params[:latitude], params[:longitude]]
        render :show, formats: :json
      end

      def create
        @establishment = Establishment.new(params[:establishment])

        if @establishment.save
          render status: 200, json: {establishment: @establishment}
        else
          render status: 401, json: {message: "Invalid record."}
        end
      end

      def update
        @establishment = Establishment.find(params[:id])
        @establishment.name = params["name"] if !params["name"].nil?
        @establishment.address_1 = params["address_1"] if !params["address_1"].nil?
        @establishment.city = params["city"] if !params["city"].nil?
        @establishment.state = params["state"] if !params["zipcode"].nil?
        @establishment.phone = params["phone"] if !params["phone"].nil?
        @establishment.zipcode = params["zipcode"] if !params["zipcode"].nil?
        @establishment.website = params["website"] if !params["website"].nil?
        @establishment.facebook_url = params["facebook_url"] if !params["facebook_url"].nil?
        @establishment.twitter_url = params["twitter_url"] if !params["twitter_url"].nil?
        @establishment.youtube_url = params["youtube_url"] if !params["youtube_url"].nil?
        @establishment.description = params["description"] if !params["description"].nil?
        @establishment.featured_text = params["featured_text"] if !params["featured_text"].nil?
        if @establishment.save
          render status: 200, json: {establishment: @establishment}
        else
          render status: 403, json: {establishment: @establishment}
        end
      end

      def custom_update
        @establishment = Establishment.find(params[:id])

        if @establishment.update_attributes(params[:establishment])
          render status: 200, json: {establishment: @establishment}
        else
          render status: 403, json: {establishment: @establishment}
        end
      end

      def favorite
        process_token
        @establishment = Establishment.find(params[:id])
        if Favorite.where(:establishment_id => params[:id], :user_id => @current_user.id).exists?
          # remove the favorite
          Favorite.where(:establishment_id => params[:id], :user_id => @current_user.id).first.destroy
          render status: 200, json: {establishment: @establishment}
        else # create favorite
          favorite = Favorite.new
          favorite.user_id = @current_user.id
          favorite.establishment_id = @establishment.id
          if favorite.save
            render status: 200, json: {establishment: @establishment}
          else #error
            render status: 403, json: {establishment: @establishment}
          end
        end
      end

      def category
        process_token
        if @current_user == nil
          render status 401
        else
          #make sure they are the owner
          if Establishment.where(:id => params["id"]).exists?
            establishment = Establishment.find(params["id"])
            if establishment.user_id == @current_user.id # they own the establishment
              #check if the category exists on the model
              has_category = false
              establishment.establishment_categories.each do |category|
                if category.id == params["category_id"].to_i #remove it
                  has_category = true
                  establishment.establishment_categories.delete(category)
                  establishment.save
                  render 200, json: {checked: false}
                  break
                end
              end
              if !has_category #add it
                c = EstablishmentCategory.find(params['category_id'])
                establishment.establishment_categories << c
                establishment.save
                render 200, json: {checked: true}
              end
            else
              render 401
            end
          else
            render 404
          end
        end
      end

      def claim
        process_token
        user = Hash.new
        user["name"] = params[:name]
        user["title"] = params[:title]
        user["email"] = params[:email]
        user["phone"] = params[:phone]
        user["time"] = params[:time]
        if Establishment.where(:id => params[:id]).exists?
          @establishment = Establishment.find(params[:id])
          if ClaimMailer.claim_email("marcus_317@yahoo.com",user, @establishment).deliver
            render status: 200, json: {establishment: @establishment}
          end
        else
          render status: 403, json: {message: "Can't find establishment"}
        end
      end

      def mine
        process_token
        if @current_user == nil #user not logged in
          render status: 200, json: {establishment: nil}
        else
          if Establishment.where(:user_id => @current_user.id).exists?
            @mine = Establishment.where(:user_id => @current_user.id)

            render :mine, formats: :json
          else
            render status: 200, json: {establishment: nil}
          end
        end
      end

      def suggest
        radius = params[:radius].nil? || params[:radius].blank? ? 2000 : params[:radius]
        current_location = [params[:latitude], params[:longitude]]
        if params["type"] == "establishment"
          Rails.logger.info params["text"]
          @search = Establishment.search do
            fulltext params["text"]
            without :latitude, nil
            without :city, nil
            without :state, nil
            order_by_geodist(:location, current_location.first, current_location.last)
          end
          @establishments = @search.results
          @establishments = @establishments.delete_if{|e| e.name.nil? || e.name.blank?}
          @establishments = @establishments.sort_by{ |e| e.name }
          @establishments.each do |e|
            e.name = e.name + " - " + e.city + ", " + e.state
          end
          render status: 200, json: @establishments
        elsif params["type"] == "category"
          @categories = EstablishmentCategory.order("grouporder ASC, sort_order ASC").all
          @categories = @categories.delete_if { |c| c.title.nil? || c.title == "" }
          render status: 200, json: @categories
        elsif params["type"] == "city"
          @cities = Establishment.order("city ASC").all.map{ |establishment| { "city" => establishment.city, "state" => establishment.state } }.uniq
          #filter out all cities that don't match the name
          @cities = @cities.delete_if { |citystate| citystate.nil? || citystate["city"].nil? || citystate["state"].nil? }
          # sort by state then city name
          #@cities = @cities.sort_by { |a| a['city']} 
          render status: 200, json: @cities
        else
          render status: 404, json:{}
        end
      end

      def process_token
        token = params[:token]
        @current_user = User.find_by_authentication_token(token)
      end

      def authenticate!
        process_token
        render status: 401, json: {message: 'Not authorized'} unless @current_user
      end
    end
  end
end
