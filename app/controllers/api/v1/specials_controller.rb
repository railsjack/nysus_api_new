module Api
  module V1
    class SpecialsController < ApplicationController
      def create

        @special = Special.new
        @special.title = params["title"]
        @special.description = params["description"]
        @special.price = params["price"] if !params["price"].nil?
        @special.start_time = parse_datetime(params["start_time"])

        @special.establishment_id = params["establishment_id"]
        @special.recurring = params["recurring"]

        if @special.save
          render status: 200, json: {special: @special}
        else
          render status: 401, json: {message: @special.errors}
        end
      end

      def parse_datetime(original)
        return DateTime.strptime(original, '%m/%d/%y %A')
      end

      def show
        @special = Special.find(params[:id])
        current_location = [params[:latitude], params[:longitude]]
        @current_location = current_location
        render :show, formats: :json
      end

      def update
        if !Special.where(id: params[:id]).exists?
          render status: 404
        else
          @special = Special.find(params[:id])
          @special.title = params["title"] if !params["title"].nil?
          @special.description = params["description"] if !params["description"].nil?
          @special.start_time = parse_datetime(params["start_time"]) if !params["title"].nil?
          @special.end_time = parse_datetime(params["end_time"]) if !params["end_time"].nil?
           @special.recurring = params["recurring"] if !params["recurring"].nil?
          if @special.save
            render status: 200, json: {special: @special}
          else
            render status: 401, json: "error"
          end 
        end
      end

      def index
        radius = params[:radius].nil? || params[:radius].blank? ? 2000 : params[:radius]
        current_location = [params[:latitude], params[:longitude]]
        # @specials = Special.all
        @search = Special.search do
          with(:location).in_radius(current_location.first, current_location.last, radius)
          order_by_geodist(:location, current_location.first, current_location.last)
        end
        @specials = @search.results
        @current_location = current_location

        render :index, formats: :json
      end

      def destroy
        if Special.where(:id => params["id"]).exists?
          if Special.where(:id => params["id"]).first.destroy
            render status: 200, json: {success: true}
          else
            render status: 500, json: {success: false}
          end
        else
          render status: 404, json: {success: false}
        end
      end

      def custom_update
        @special = Special.find(params[:id])

        if @special.update_attributes(params[:special])
          render status: 200, json: {special: @special}
        else
          render status: 403, json: {special: @special}
        end
      end
    end
  end
end
