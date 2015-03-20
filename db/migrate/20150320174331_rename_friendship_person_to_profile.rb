class RenameFriendshipPersonToProfile < ActiveRecord::Migration
  def up
    rename_column :friendships, :person_id, :profile_id
  end

  def down
    rename_column :friendships, :profile_id, :person_id
  end
end
