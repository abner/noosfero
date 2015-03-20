class Friendship < ActiveRecord::Base
  track_actions :new_friendship, :after_create, :keep_params => ["friend.name", "friend.url", "friend.profile_custom_icon"], :custom_user => :profile

  extend CacheCounterHelper

  belongs_to :profile, :foreign_key => :profile_id
  belongs_to :friend, :class_name => 'Profile', :foreign_key => 'friend_id'

  after_create do |friendship|
    Friendship.update_cache_counter(:friends_count, friendship.profile, 1)
    Friendship.update_cache_counter(:friends_count, friendship.friend, 1)
  end

  after_destroy do |friendship|
    Friendship.update_cache_counter(:friends_count, friendship.profile, -1)
    Friendship.update_cache_counter(:friends_count, friendship.friend, -1)
  end

  def self.remove_friendship(profile1, profile2)
    profile1.remove_friend(profile2)
    profile2.remove_friend(profile1)
  end
end
