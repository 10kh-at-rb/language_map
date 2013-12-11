class Repository < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
  validates :language, presence: true
  validates :location, presence: true

  def self.has_latlong
    self.where("latitude IS NOT NULL AND longitude IS NOT NULL")
  end
end
