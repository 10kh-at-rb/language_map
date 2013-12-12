class Repository < ActiveRecord::Base
  validates :sha, presence: true, uniqueness: true
  validates :url, presence: true
  validates :language, presence: true
  validates :location, presence: true

  def self.has_latlong
    self.where("latitude IS NOT NULL AND longitude IS NOT NULL")
  end

  def self.languages
    self.distinct.pluck(:language)
  end

  def self.in_language(language)
    self.where(language: language)
  end

  def self.ruby_long_lat
    self.has_latlong.in_language("Ruby").map{|r| [r.longitude, r.latitude]}
  end
end
