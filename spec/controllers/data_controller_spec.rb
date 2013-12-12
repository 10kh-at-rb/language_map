require 'spec_helper'

describe DataController do
  describe "POST to :upload_csv" do
    it "uploads csv" do
      file = fixture_file_upload 'data.csv', 'text/csv'
      CsvImporter.should_receive(:import).with(file)
      post :upload_csv, :file => file
      response.should be_success
    end
  end
end
