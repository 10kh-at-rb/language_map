require 'spec_helper'

describe CsvImporter do
  describe '#import' do
    it "imports csv and creates a Repository record for each row" do
      CsvImporter.new(csv).import
      expect(Repository.count).to be(4)
    end

    it "sets the correct url attribute" do
      CsvImporter.new(csv).import
      urls = [0,1,2,3].map { |n| "https://github.com/user#{n}/repo#{n}" }
      expect(Repository.all.map(&:url)).to eq(urls)
    end

    it "sets the correct language attribute when language is present" do
      CsvImporter.new(csv).import
      expect(Repository.all.map(&:language)).to include("Ruby", "JavaScript", "C++")
    end

    it "sets language to nil when CSV value is null" do
      CsvImporter.new(csv).import
      expect(Repository.last.language).to be_nil
    end

    it "sets full location regardless of presence of commas" do
      CsvImporter.new(csv).import
      locations = ["Washington, DC", "San Francisco", "Horncastle, Lincolnshire, UK", "Moscow, Russia"]
      expect(Repository.all.map(&:location)).to eq(locations)
    end
  end
end

private

def csv
  csv_data = %q{https://github.com/user0/repo0,Ruby,Washington, DC
https://github.com/user1/repo1,JavaScript,San Francisco
https://github.com/user2/repo2,C++,Horncastle, Lincolnshire, UK
https://github.com/user3/repo3,null,Moscow, Russia}
  StringIO.new(csv_data)
end
