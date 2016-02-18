class WorklistsController < ApplicationController
  def index
    @worklists = Worklist.all
  end

  def show
    @worklist = Worklist.find(params[:id], params: { include_items: true })
  end
end
