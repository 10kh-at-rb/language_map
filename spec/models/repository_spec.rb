require 'spec_helper'

describe Repository do
  describe ".has_latlong" do
    let!(:repo_with_latlong)    { FactoryGirl.create(:repository, latitude: 38.9072309, longitude: -77.0364641) }
    let!(:repo_without_latlong) { FactoryGirl.create(:repository, location: "New York") }

    it "includes repos with latlong and excludes repos without" do
      has_latlong = Repository.has_latlong
      expect(has_latlong).to have(1).item
      expect(has_latlong).to include(repo_with_latlong)
      expect(has_latlong).not_to include(repo_without_latlong)
    end
  end
end
