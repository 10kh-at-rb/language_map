require 'csv'

class CsvImporter

  def self.import(csv)
    CSV.parse(File.read(csv)) do |row|
      r = Repository.new
      r.sha = row[0] unless row[0] == "null"
      r.url = row[1] unless row[1] == "null"
      r.language = row[2] unless row[2] == "null"
      r.location = row[3..-1].join(",") unless row[3] == "null"
      r.save
    end
  end
end
