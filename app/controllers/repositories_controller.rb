class RepositoriesController < ApplicationController
  def index
    render json: Repository.has_latlong
  end
end
