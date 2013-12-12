class DataController < ApplicationController
  def show
  end

  def upload_csv
    CsvImporter.import(params[:file].path)
    flash[:notice] = "File uploaded"
    redirect_to data_path
  end
end
