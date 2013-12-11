namespace :latlong do
  task :populate => :environment do
    LatlongPopulator.new.run
  end
end
