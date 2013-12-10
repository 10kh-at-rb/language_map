class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :url
      t.string :language
      t.string :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
