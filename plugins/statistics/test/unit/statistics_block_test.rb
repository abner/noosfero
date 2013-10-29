require File.dirname(__FILE__) + '/../test_helper'
class StatisticsBlockTest < ActiveSupport::TestCase
  
  ['user_stat', 'tag_stat', 'comment_stat', 'hit_stat'].map do |stat|
    should "#{stat} be true by default" do
      b = StatisticsBlock.new
      assert b.is_visible?(stat)
    end
  end
  
  ['community_stat', 'enterprise_stat', 'category_stat'].map do |stat|
    should "#{stat} be false by default" do
      b = StatisticsBlock.new
      assert !b.is_visible?(stat)
    end
  end

  should 'inherit from Block' do
    assert_kind_of Block, StatisticsBlock.new
  end

  should 'provide a default title' do
    block = StatisticsBlock.new

    owner = mock
    owner.expects(:name).returns('my environment')
    block.expects(:owner).returns(owner)
    assert_equal 'Statistics for my environment', block.title
  end

  should 'describe itself' do
    assert_not_equal StatisticsBlock.description, Block.description 
  end

  should 'is_visible? return true if setting is true' do
    b = StatisticsBlock.new
    b.community_stat = true
    assert b.is_visible?('community_stat')
  end

  should 'is_visible? return false if setting is false' do
    b = StatisticsBlock.new
    b.community_stat = false
    assert !b.is_visible?('community_stat')
  end
  
  should 'templates return the Community templates of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    t1 = fast_create(Community, :is_template => true, :environment_id => e.id)
    t2 = fast_create(Community, :is_template => true, :environment_id => e.id)
    fast_create(Community, :is_template => false)
    
    b.expects(:owner).at_least_once.returns(e)
    
    t = b.templates
    assert_equal [], [t1,t2] - t
    assert_equal [], t - [t1,t2]
  end
  
  should 'users return the amount of users of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Person, :environment_id => e.id)
    fast_create(Person, :environment_id => e.id)
    fast_create(Person, :visible => false, :environment_id => e.id)
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 2, b.users
  end
  
  should 'users return the amount of members of the community' do
    b = StatisticsBlock.new
    
    c1 = fast_create(Community)
    c1.add_member(fast_create(Person))
    c1.add_member(fast_create(Person))
    c1.add_member(fast_create(Person))
    c1.add_member(fast_create(Person, :visible => false))
    c1.add_member(fast_create(Person, :visible => false))
    
    b.expects(:owner).at_least_once.returns(c1)
    assert_equal 3, b.users
  end  
  
  should 'users return the amount of friends of the person' do
    b = StatisticsBlock.new
    
    p1 = fast_create(Person)
    p1.add_friend(fast_create(Person))
    p1.add_friend(fast_create(Person))
    p1.add_friend(fast_create(Person))
    p1.add_friend(fast_create(Person, :visible => false))
    p1.add_friend(fast_create(Person, :visible => false))
    
    b.expects(:owner).at_least_once.returns(p1)
    assert_equal 3, b.users
  end  

  should 'communities return the amount of communities of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Community, :environment_id => e.id)
    fast_create(Community, :environment_id => e.id)
    fast_create(Community, :visible => false, :environment_id => e.id)
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 2, b.communities
  end
  
  should 'enterprises return the amount of enterprises of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Enterprise, :environment_id => e.id)
    fast_create(Enterprise, :environment_id => e.id)
    fast_create(Enterprise, :visible => false, :environment_id => e.id)
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 2, b.enterprises
  end

  should 'categories return the amount of categories of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Category, :environment_id => e.id)
    fast_create(Category, :environment_id => e.id)
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 2, b.categories
  end

  should 'tags return the amount of tags of the Environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)

    p1 = fast_create(Person, :environment_id => e.id)    
    a1 = fast_create(Article, :profile_id => p1.id)
    t1 = fast_create(Tag, :name => 'T1')
    t2 = fast_create(Tag, :name => 'T2')
    a1.tags << t1
    a1.tags << t2
    a2 = fast_create(Article, :profile_id => p1.id)
    t3 = fast_create(Tag, :name => 'T3')
    t4 = fast_create(Tag, :name => 'T4')
    a2.tags << t3
    a2.tags << t4
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 4, b.tags
  end
  
  should 'tags return the amount of tags of the community' do
    b = StatisticsBlock.new
    e = fast_create(Environment)

    c1 = fast_create(Community, :environment_id => e.id)    
    a1 = fast_create(Article, :profile_id => c1.id)
    t1 = fast_create(Tag, :name => 'T1')
    t2 = fast_create(Tag, :name => 'T2')
    a1.tags << t1
    a1.tags << t2
    a2 = fast_create(Article, :profile_id => c1.id)
    t3 = fast_create(Tag, :name => 'T3')
    t4 = fast_create(Tag, :name => 'T4')
    a2.tags << t3
    a2.tags << t4
    
    b.expects(:owner).at_least_once.returns(c1)
    
    assert_equal 4, b.tags
  end

  should 'tags return the amount of tags of the profile (person)' do
    b = StatisticsBlock.new
    e = fast_create(Environment)

    p1 = fast_create(Person, :environment_id => e.id)    
    a1 = fast_create(Article, :profile_id => p1.id)
    t1 = fast_create(Tag, :name => 'T1')
    t2 = fast_create(Tag, :name => 'T2')
    a1.tags << t1
    a1.tags << t2
    a2 = fast_create(Article, :profile_id => p1.id)
    t3 = fast_create(Tag, :name => 'T3')
    t4 = fast_create(Tag, :name => 'T4')
    a2.tags << t3
    a2.tags << t4
    
    b.expects(:owner).at_least_once.returns(p1)
    
    assert_equal 4, b.tags
  end

  should 'is_valid? return true for all stats if owner is environment' do
    b = StatisticsBlock.new
    e = fast_create(Environment)

    b.expects(:owner).at_least_once.returns(e)
    
    assert b.is_valid?(:user_stat)
  end

  should 'is_template_stat_active? return true if setting is true' do
    b = StatisticsBlock.new
    b.templates_ids_stat = {'1' => 'true'}
    assert b.is_template_stat_active?(1)
  end

  should 'is_template_stat_active? return false if setting is false' do
    b = StatisticsBlock.new
    b.templates_ids_stat = {'1' => 'false'}
    assert !b.is_template_stat_active?(1)
  end

  should 'template_stat_count return the amount of communities of the Environment using a template' do
    b = StatisticsBlock.new
    e = fast_create(Environment)
    
    t1 = fast_create(Community, :is_template => true, :environment_id => e.id)
    t2 = fast_create(Community, :is_template => true, :environment_id => e.id)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => false)

    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t2.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t2.id, :visible => false)
    
    b.expects(:owner).at_least_once.returns(e)
    
    assert_equal 2, b.template_stat_count(t1.id)
  end
end
