require 'spec_helper'

describe CsvImporter do
  describe '.import' do
    describe "clean data" do
      let(:csv) { mock_csv(
        "1a2b3c4d5e,https://github.com/user0/repo0,Ruby,Washington, DC\n"\
        "6f7g8h9i0j,https://github.com/user1/repo1,JavaScript,San Francisco\n"\
        "5k4l3m2n1o,https://github.com/user2/repo2,C++,Horncastle, Lincolnshire, UK\n"\
        "0p9q8r7s6t,https://github.com/user3/repo3,Objective-C,Moscow, Russia\n"
      ) }

      it "imports csv and creates a Repository record for each row" do
        CsvImporter.import(csv)
        expect(Repository.count).to be(4)
      end

      it "sets the correct sha attribute" do
        CsvImporter.import(csv)
        urls = %w[1a2b3c4d5e 6f7g8h9i0j 5k4l3m2n1o 0p9q8r7s6t].sort
        expect(Repository.all.map(&:sha)).to include(*urls)
      end

      it "sets the correct url attribute" do
        CsvImporter.import(csv)
        urls = [0,1,2,3].map { |n| "https://github.com/user#{n}/repo#{n}" }
        expect(Repository.all.map(&:url)).to include(*urls)
      end

      it "sets the correct language attribute when language is present" do
        CsvImporter.import(csv)
        languages = ["Ruby", "JavaScript", "C++", "Objective-C"]
        expect(Repository.all.map(&:language)).to include(*languages)
      end

      it "sets full location regardless of presence of commas" do
        CsvImporter.import(csv)
        locations = ["Washington, DC", "San Francisco", "Horncastle, Lincolnshire, UK", "Moscow, Russia"]
        expect(Repository.all.map(&:location)).to include(*locations)
      end
    end

    describe "null repository" do
      let(:csv) { mock_csv("null,Ruby,Washington, DC\n") }

      it "does not create a new record" do
        expect{CsvImporter.import(csv)}.not_to change{Repository.count}
      end
    end

    describe "null language" do
      let(:csv) { mock_csv("https://github.com/user0/repo0,null,Washington, DC\n") }

      it "does not create a new record" do
        expect{CsvImporter.import(csv)}.not_to change{Repository.count}
      end
    end

    describe "null location" do
      let(:csv) { mock_csv("https://github.com/user0/repo0,Ruby,null\n") }

      it "does not create a new record" do
        expect{CsvImporter.import(csv)}.not_to change{Repository.count}
      end
    end
  end
end

private

def mock_csv(csv_string)
  File.expects(:read).returns(StringIO.new(csv_string))
end
