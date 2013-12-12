class AddShaToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :sha, :string
  end
end
