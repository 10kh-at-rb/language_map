class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.has_latlong
    render json: @repositories
  end
end
