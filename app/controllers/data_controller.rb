class DataController < ApplicationController
  def show
  end

  def upload_csv
    CsvImporter.import(params[:file].path)
    flash[:notice] = "File uploaded"
    redirect_to data_path
  end

  def map
  end

  def map_json
    data = File.read('vendor/json/world-50m.json')
    render json: data
  end
end
