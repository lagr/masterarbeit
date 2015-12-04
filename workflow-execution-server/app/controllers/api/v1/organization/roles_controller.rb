module Api::V1::Organization
  class RolesController < ApplicationController
    before_filter :find_model

    private
    def find_model
      @model = Roles.find(params[:id]) if params[:id]
    end
  end
end
