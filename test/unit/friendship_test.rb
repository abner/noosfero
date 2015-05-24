require_relative "../test_helper"

class FriendshipTest < ActiveSupport::TestCase

  should 'connect a person to another' do
    p1 = create(:person)
    p2 = create(:person)

    f = Friendship.new
    assert_raise ActiveRecord::AssociationTypeMismatch do
      f.person = Organization.new
    end
    assert_raise ActiveRecord::AssociationTypeMismatch do
      f.friend = Organization.new
    end
    assert_nothing_raised do
      f.person = p1
      f.friend = p2
    end

    f.save!

  end

  should 'create tracked action' do
    a, b, c = create(:person)
    f = Friendship.new
    f.person = a
    f.friend = b
    f.save!
    ta = ActionTracker::Record.last
    assert_equal a, ta.user
    assert_equal 'b', ta.get_friend_name[0]
    f = Friendship.new
    f.person = a
    f.friend = c
    f.save!
    ta = ActionTracker::Record.last
    assert_equal a, ta.user
    assert_equal 'c', ta.get_friend_name[1]
  end

  should 'create tracked action for both people' do
    a, b = create(:person)
    f = Friendship.new
    f.person = a
    f.friend = b
    f.save!
    ta = ActionTracker::Record.last
    assert_equal a, ta.user
    assert_equal ['b'], ta.get_friend_name
    f = Friendship.new
    f.person = b
    f.friend = a
    f.save!
    ta = ActionTracker::Record.last
    assert_equal b, ta.user
    assert_equal ['a'], ta.get_friend_name
  end

  should 'remove friendships when a friend removal occurs' do
    p1 = create(:person)
    p2 = create(:person)
    p1.add_friend(p2, 'friends')
    p2.add_friend(p1, 'friends')

    assert_difference 'Friendship.count', -2 do
      Friendship.remove_friendship(p1, p2)
    end

    assert_not_includes p1.friends(true), p2
    assert_not_includes p2.friends(true), p1
  end

end
