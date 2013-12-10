class Repository < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
  validates :language, presence: true
  validates :location, presence: true
end
