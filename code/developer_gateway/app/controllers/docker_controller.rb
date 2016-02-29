class ActivitiesController < ApplicationController
  def index
    @images = mq_request 'docker.index', 'docker.indexed', term: params[:term]
    render json: @images
  end
end
