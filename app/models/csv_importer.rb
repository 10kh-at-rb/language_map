require 'csv'

class CsvImporter
  attr_reader :csv

  def initialize(csv)
    @csv = csv
  end

  def import
    CSV.parse(csv) do |row|
      r = Repository.new
      r.url = row[0]
      r.language = row[1] unless row[1] == "null"
      r.location = row[2..-1].join(",") unless row[2] == "null"
      r.save
    end
  end
end
