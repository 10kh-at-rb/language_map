require 'spec_helper'

describe LatlongPopulator do
  describe "#run" do
    let!(:repo_with_latlong)    { FactoryGirl.create(:repository, latitude: 38.9072309, longitude: -77.0364641) }
    let!(:repo_without_latlong) { FactoryGirl.create(:repository, location: "New York") }
    let(:geocoder_response)     { stub(data: { "geometry" => { "location" => { "lat" => 12.345, "lng" => 67.89 } } }) }

    it "only runs for repositories with nil latitude and longitude" do
      Geocoder.expects(:search).with("New York").returns([geocoder_response])
      Geocoder.expects(:search).with("Washington, DC").never
      LatlongPopulator.new.run
    end

    it "adds latitude and longitude to db records" do
      Geocoder.expects(:search).with("New York").returns([geocoder_response])
      LatlongPopulator.new.run
      expect(repo_without_latlong.reload.latitude).to eq 12.345
      expect(repo_without_latlong.reload.longitude).to eq 67.89
    end

    it "doesn't throw an error if Geocoder returns empty array" do
      Geocoder.expects(:search).with("New York").returns([])
      expect{LatlongPopulator.new.run}.not_to raise_error
    end
  end
end

# def geocoder_response
#   stub(data: { "geometry" => { "location" => { "lat" => 12.345, "lng" => 67.89 } } })
# end
