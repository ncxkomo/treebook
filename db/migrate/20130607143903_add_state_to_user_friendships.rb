class AddStateToUserFriendships < ActiveRecord::Migration
  def change
  	add_column :user_friendships, :state, :string
  	add_index :user_friendships, :state # because will be accessing by state often
  end
end
