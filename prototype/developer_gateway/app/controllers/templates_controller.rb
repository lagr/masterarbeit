class TemplatesController < ApplicationController
  layout false
  def serve
    @template = params[:template]
  end
end
