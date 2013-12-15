require 'spec_helper'

describe LatlongPopulator do
  describe "#run" do
    let!(:repo_with_latlong)    { FactoryGirl.create(:repository, latitude: 38.9072309, longitude: -77.0364641) }
    let!(:repo_without_latlong) { FactoryGirl.create(:repository, location: "New York") }

    it "only runs for repositories with nil latitude and longitude" do
      Geocoder.expects(:coordinates).with("New York").returns([12.345, 67.89])
      Geocoder.expects(:coordinates).with("Washington, DC").never
      LatlongPopulator.new.run
    end

    it "adds latitude and longitude to db records" do
      Geocoder.expects(:coordinates).with("New York").returns([12.345, 67.89])
      LatlongPopulator.new.run
      expect(repo_without_latlong.reload.latitude).to eq 12.345
      expect(repo_without_latlong.reload.longitude).to eq 67.89
    end

    it "doesn't throw an error if Geocoder returns empty array" do
      Geocoder.expects(:coordinates).with("New York").returns(nil)
      expect{LatlongPopulator.new.run}.not_to raise_error
    end

    it "removes weird characters" do
      repo_without_latlong.update_attribute :location, "G��teborg, Sweden"
      Geocoder.expects(:coordinates).with( "Gteborg, Sweden").returns(nil)
      LatlongPopulator.new.run
    end
  end
end
