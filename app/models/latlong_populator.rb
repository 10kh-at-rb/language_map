class LatlongPopulator
  def run
    repositories.each do |repo|
      puts "Finding #{repo.location}...\n"
      location = force_encoding_for(repo.location)
      resp = Geocoder.search(location).first
      update_repo(repo, resp) if resp
    end
  end

  private

  def repositories
    Repository.where("latitude IS NULL AND longitude IS NULL")
  end

  def update_repo(repo, resp)
    latlong = resp.data["geometry"]["location"]
    lat, lng = latlong["lat"], latlong["lng"]
    repo.update_attributes latitude: lat, longitude: lng
  end

  def force_encoding_for(location)
    location.force_encoding("binary").encode("UTF-8",
                                             invalid: :replace,
                                             undef:   :replace,
                                             replace: ""
                                            )
  end
end
