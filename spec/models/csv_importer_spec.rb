require 'spec_helper'

describe CsvImporter do
  describe '#import' do
    describe "clean data" do
      let(:csv) { mock_csv(
        "https://github.com/user0/repo0,Ruby,Washington, DC\n"\
        "https://github.com/user1/repo1,JavaScript,San Francisco\n"\
        "https://github.com/user2/repo2,C++,Horncastle, Lincolnshire, UK\n"\
        "https://github.com/user3/repo3,Objective-C,Moscow, Russia\n"
      ) }

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
        languages = ["Ruby", "JavaScript", "C++", "Objective-C"]
        expect(Repository.all.map(&:language)).to eq(languages)
      end

      it "sets full location regardless of presence of commas" do
        CsvImporter.new(csv).import
        locations = ["Washington, DC", "San Francisco", "Horncastle, Lincolnshire, UK", "Moscow, Russia"]
        expect(Repository.all.map(&:location)).to eq(locations)
      end
    end

    describe "null repository" do
      let(:csv) { mock_csv("null,Ruby,Washington, DC\n") }

      it "does not create a new record" do
        expect{CsvImporter.new(csv).import}.not_to change{Repository.count}
      end
    end

    describe "null language" do
      let(:csv) { mock_csv("https://github.com/user0/repo0,null,Washington, DC\n") }

      it "does not create a new record" do
        expect{CsvImporter.new(csv).import}.not_to change{Repository.count}
      end
    end

    describe "null location" do
      let(:csv) { mock_csv("https://github.com/user0/repo0,Ruby,null\n") }

      it "does not create a new record" do
        expect{CsvImporter.new(csv).import}.not_to change{Repository.count}
      end
    end
  end
end

private

def mock_csv(csv_string)
  expect(File).to receive(:read).and_return(StringIO.new(csv_string))
end
