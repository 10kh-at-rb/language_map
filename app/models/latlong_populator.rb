class LatlongPopulator
  def run
    repositories.each do |repo|
      puts "Finding #{repo.location}...\n"
      location = force_encoding_for(repo.location)
      lat, lng = Geocoder.coordinates(location)
      repo.update_attributes latitude: lat, longitude: lng if lat && lng
    end
  end

  private

  def repositories
    Repository.where("latitude IS NULL AND longitude IS NULL")
  end

  def force_encoding_for(location)
    location.force_encoding("binary").encode("UTF-8",
                                             invalid: :replace,
                                             undef:   :replace,
                                             replace: ""
                                            )
  end
end
