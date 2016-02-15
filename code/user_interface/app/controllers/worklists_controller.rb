class WorklistsController < ApplicationController
  # GET /worklists
  # GET /worklists.json
  def index
    @worklists = Worklist.all
  end

  # GET /worklists/1
  # GET /worklists/1.json
  def show
    @worklist = Worklist.find(params[:id], params: { include_items: true })
  end
end
