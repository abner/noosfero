require File.dirname(__FILE__) + '/../test_helper'

class DisplayPeopleBlockTest < ActiveSupport::TestCase

  should 'inherit from Block' do
    assert_kind_of Block, DisplayPeopleBlock.new
  end


  should 'declare its default title' do
    assert_not_equal Block.new.default_title, DisplayPeopleBlock.new.default_title
  end


  should 'describe itself' do
    assert_not_equal Block.description, DisplayPeopleBlock.description
  end


  should 'is editable' do
    block = DisplayPeopleBlock.new
    assert block.editable?
  end


  should 'have field limit' do
    block = DisplayPeopleBlock.new
    assert_respond_to block, :limit
  end


  should 'default value of limit' do
    block = DisplayPeopleBlock.new
    assert_equal 6, block.limit
  end


  should 'have field name' do
    block = DisplayPeopleBlock.new
    assert_respond_to block, :name
  end


  should 'default value of name' do
    block = DisplayPeopleBlock.new
    assert_equal "", block.name
  end


  should 'have field address' do
    block = DisplayPeopleBlock.new
    assert_respond_to block, :address
  end


  should 'default value of address' do
    block = DisplayPeopleBlock.new
    assert_equal "", block.address
  end


  should 'prioritize profiles with image by default' do
    assert DisplayPeopleBlock.new.prioritize_people_with_image
  end


  should 'respect limit when listing people' do
    env = fast_create(Environment)
    p1 = fast_create(Person, :environment_id => env.id)
    p2 = fast_create(Person, :environment_id => env.id)
    p3 = fast_create(Person, :environment_id => env.id)
    p4 = fast_create(Person, :environment_id => env.id)

    block = DisplayPeopleBlock.new(:limit => 3)
    block.stubs(:owner).returns(env)

    assert_equal 3, block.profiles_list.size
  end

  should 'accept a limit of people to be displayed' do
    block = DisplayPeopleBlock.new
    block.limit = 20
    assert_equal 20, block.limit
  end


  should 'list people from environment' do
    owner = fast_create(Environment)
    person1 = fast_create(Person, :environment_id => owner.id)
    person2 = fast_create(Person, :environment_id => owner.id)

    block = DisplayPeopleBlock.new

    block.expects(:owner).returns(owner).at_least_once
    expects(:profile_image_link).with(person1, :minor).returns(person1.name)
    expects(:profile_image_link).with(person2, :minor).returns(person2.name)
    expects(:block_title).with(anything).returns('')

    content = instance_eval(&block.content)

    assert_match(/#{person1.name}/, content)
    assert_match(/#{person2.name}/, content)
  end


  should 'list members from community' do
    owner = fast_create(Community)
    person1 = fast_create(Person)
    person2 = fast_create(Person)
    owner.add_member(person1)
    owner.add_member(person2)

    block = DisplayPeopleBlock.new

    block.expects(:owner).returns(owner).at_least_once
    expects(:profile_image_link).with(person1, :minor).returns(person1.name)
    expects(:profile_image_link).with(person2, :minor).returns(person2.name)
    expects(:block_title).with(anything).returns('')

    content = instance_eval(&block.content)

    assert_match(/#{person1.name}/, content)
    assert_match(/#{person2.name}/, content)
  end


  should 'list friends from person' do
    owner = fast_create(Person)
    friend1 = fast_create(Person)
    friend2 = fast_create(Person)
    owner.add_friend(friend1)
    owner.add_friend(friend2)

    block = DisplayPeopleBlock.new

    block.expects(:owner).returns(owner).at_least_once
    expects(:profile_image_link).with(friend1, :minor).returns(friend1.name)
    expects(:profile_image_link).with(friend2, :minor).returns(friend2.name)
    expects(:block_title).with(anything).returns('')

    content = instance_eval(&block.content)

    assert_match(/#{friend1.name}/, content)
    assert_match(/#{friend2.name}/, content)
  end


  should 'link to "all members"' do
    community = fast_create(Community)

    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(community).at_least_once

    expects(:_).with('View all').returns('View all')
    expects(:link_to).with('View all', :profile => community.identifier, :controller => 'profile', :action => 'members').returns('link-to-members')

    assert_equal 'link-to-members', instance_eval(&block.footer)
  end


  should 'link to "all friends"' do
    person1 = create_user('mytestperson').person

    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(person1).at_least_once

    expects(:_).with('View all').returns('View all')
    expects(:link_to).with('View all', :profile => 'mytestperson', :controller => 'profile', :action => 'friends').returns('link-to-friends')

    assert_equal 'link-to-friends', instance_eval(&block.footer)
  end


  should 'link to "all people"' do
    env = fast_create(Environment)
    
    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(env).at_least_once

    expects(:_).with('View all').returns('View all')
    expects(:link_to).with('View all', :profile => nil, :controller => 'search', :action => 'people').returns('link-to-people')

    assert_equal 'link-to-people', instance_eval(&block.footer)
  end


  should 'count number of owner friends' do
    owner = fast_create(Person)
    friend1 = fast_create(Person)
    friend2 = fast_create(Person)
    friend3 = fast_create(Person)
    owner.add_friend(friend1)
    owner.add_friend(friend2)
    owner.add_friend(friend3)

    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(owner).at_least_once

    assert_equal 3, block.profile_count
  end


  should 'count number of public and private people' do
    owner = fast_create(Person)
    private_p = fast_create(Person, {:public_profile => false})
    public_p = fast_create(Person, {:public_profile => true})

    owner.add_friend(private_p)
    owner.add_friend(public_p)

    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(owner).at_least_once

    assert_equal 2, block.profile_count
  end


  should 'not count number of invisible people' do
    owner = fast_create(Person)
    private_p = fast_create(Person, {:visible => false})
    public_p = fast_create(Person, {:visible => true})

    owner.add_friend(private_p)
    owner.add_friend(public_p)

    block = DisplayPeopleBlock.new
    block.expects(:owner).returns(owner).at_least_once

    assert_equal 1, block.profile_count
  end

  protected
  include NoosferoTestHelper
   
end
