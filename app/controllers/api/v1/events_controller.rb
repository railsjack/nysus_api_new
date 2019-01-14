module Api
  module V1
    class EventsController < ApplicationController
      def create
        @event = Event.new
        @event.title = params["title"]
        @event.description = params["description"]
        @event.start_time = parse_datetime(params["start_time"])
        @event.establishment_id = params["establishment_id"]

        if @event.save
          render status: 200, json: {event: @event}
        else
          render status: 401, json: {message: @event.errors}
        end
      end

      def show
        @event = Event.find(params[:id])
        render status: 200, json: {event: @event}
      end

      def edit
        @event = Event.find(params[:id])
        render status: 200, json: {event: @event}
      end

      def index
        radius = params[:radius].nil? || params[:radius].blank? ? 2000 : params[:radius]
        current_location = [params[:latitude], params[:longitude]]

        @search = Event.search do
          with(:location).in_radius(current_location.first, current_location.last, radius)
          order_by_geodist(:location, current_location.first, current_location.last)
        end
        @events = @search.results
        @current_location = current_location
      end

      def update
        if !Event.where(id: params[:id]).exists?
          render status: 404
        else
          @event = Event.find(params[:id])
          @event.title = params["title"] if !params["title"].nil?
          @event.description = params["description"] if !params["description"].nil?
          @event.price = params["price"] if !params["price"].nil?
          @event.start_time = parse_datetime(params["start_time"])
          @event.end_time = parse_datetime(params["end_time"]) if !params["end_time"].nil?
          if @event.save
            render status: 200, json: {event: @event}
          else
            render status: 401, json: "error"
          end
        end
      end

      def parse_datetime(original)
        return DateTime.strptime(original, '%m/%d/%Y %l:%M %p') if original.split.length == 3
        return DateTime.strptime(original, '%m/%d/%Y %a %l:%M %p')  if original.split.length == 4
        return false
      end

      def destroy
        if Event.where(:id => params["id"]).exists?
          if Event.where(:id => params["id"]).first.destroy
            render status: 200, json: {success: true}
          else
            render status: 500, json: {success: false}
          end
        else
          render status: 404, json: {success: false}
        end
      end

      def custom_update
        @event = Event.find(params[:id])

        if @event.update_attributes(params[:event])
          render status: 200, json: {event: @event}
        else
          render status: 403, json: {event: @event}
        end
      end
    end
  end
end
