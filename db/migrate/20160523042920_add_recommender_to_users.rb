class AddRecommenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recommender, :integer
    add_index :users, :recommender
  end
end
