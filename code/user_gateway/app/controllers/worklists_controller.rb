class WorklistsController < ApplicationController
  def index
    @users = mq_request 'user.index', 'user.indexed', {}
  end
end
