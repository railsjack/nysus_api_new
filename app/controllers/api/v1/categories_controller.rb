module Api
  module V1
    class CategoriesController < ApplicationController

      def index
        @categories = EstablishmentCategory.all
        render status: 200, json: {categories: @categories}
      end

    end
  end
end
